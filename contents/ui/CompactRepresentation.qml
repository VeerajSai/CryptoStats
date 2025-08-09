import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "components" as Components

RowLayout {
    id: wrapper

    property int pixelFontVar: Plasmoid.configuration.fontSize
    property int pixelFontVar2: pixelFontVar * 0.7
    property int heightroot: Math.max(pixelFontVar + 4, 5) // Dynamic height based on font size
    property string currencyPair: "Unknown Pair"

    // Function for thousands separator
    function formatPrice(price) {
        // Ensure price is always a number
        let numPrice = parseFloat(price);

        // Check if it's a valid number
        if (isNaN(numPrice)) {
            return price; // Return original value if not a valid number
        }

        // Apply thousand separator if needed
        let formattedPrice = numPrice.toFixed(Plasmoid.configuration.decimalPlaces);

        // If swapCommasDots is enabled, swap commas and dots
        if (Plasmoid.configuration.swapCommasDots) {
            // Swap the dot in the decimal place to a comma
            formattedPrice = formattedPrice.replace('.', ',');

            // Apply thousands separator using a dot (if thousands separator is enabled)
            if (Plasmoid.configuration.useThousandsSeparator) {
                formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            }
        } else {
            // If swapCommasDots is not enabled, apply thousands separator with dot
            if (Plasmoid.configuration.useThousandsSeparator) {
                formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            }
        }

        // Return the formatted price
        return formattedPrice;
    }

    Layout.minimumWidth: {
        var currencyPairText = "";
        if (Plasmoid.configuration.showCurrencyName) {
            currencyPairText = (Plasmoid.configuration.cryptoCurrency || "???") + "/" + 
                              (Plasmoid.configuration.fiatCurrency || "???") + ": ";
        }
        var fullText = currencyPairText + displayedPrice;
        return fullText.length * pixelFontVar * 0.6 + 10; // Reduced padding
    }
    Layout.minimumHeight: heightroot
    Layout.maximumHeight: heightroot + 2 // Limit maximum height to prevent extra spacing

    Components.CurlAPI {
        id: curlApi
        cryptoCurrency: Plasmoid.configuration.cryptoCurrency
        fiatCurrency: Plasmoid.configuration.fiatCurrency
        refreshRate: Plasmoid.configuration.timeRefresh || 5 // Integrating the refresh rate configuration (in seconds)
        priceMultiplier: parseFloat(Plasmoid.configuration.priceMultiplier) || 1.0
        decimalPlaces: Plasmoid.configuration.decimalPlaces || 3
    }

    Connections {
        target: Plasmoid.configuration
        
        function onCryptoCurrencyChanged() {
            curlApi.cryptoCurrency = Plasmoid.configuration.cryptoCurrency;
            curlApi.updatePrice();
        }
        
        function onFiatCurrencyChanged() {
            curlApi.fiatCurrency = Plasmoid.configuration.fiatCurrency;
            curlApi.updatePrice();
        }
        
        function onPriceMultiplierChanged() {
            curlApi.priceMultiplier = parseFloat(Plasmoid.configuration.priceMultiplier) || 1.0;
            curlApi.updatePrice();
        }
    }

    // Determine which price text should be shown with multiplier applied
    property string displayedPrice: {
        if (curlApi.price === "E") {
            return "Err";
        }
        if (curlApi.price !== null && !isNaN(curlApi.price)) {
            // Apply price multiplier from configuration
            var price = parseFloat(curlApi.price);
            return formatPrice(price.toFixed(Plasmoid.configuration.decimalPlaces));
        }
        return "?";
    }

    Text {
        id: combinedText
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignVCenter // Ensure vertical centering
        font.pixelSize: pixelFontVar
        color: {
            if (displayedPrice === "Err") {
                return Plasmoid.configuration.errorColor || Kirigami.Theme.negativeTextColor;
            }
            return Plasmoid.configuration.textColor || Kirigami.Theme.textColor;
        }
        font.bold: Plasmoid.configuration.textBold
        text: {
            var currencyPair = "";
            if (Plasmoid.configuration.showCurrencyName) {
                currencyPair = (Plasmoid.configuration.cryptoCurrency || "???") + "/" + 
                              (Plasmoid.configuration.fiatCurrency || "???") + 
                              (Plasmoid.configuration.priceMultiplier !== "1" && Plasmoid.configuration.priceMultiplier !== "" ? "*: " : ": ");
            }
            return currencyPair + displayedPrice;
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap // Prevent text wrapping that could cause height issues
        opacity: 1.0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            curlApi.updatePrice(); // Update price when clicking
            fadeAnimation.start();
        }
    }

    // Simple color animation for visual feedback
    ColorAnimation {
        id: priceFlash
        target: combinedText
        property: "color"
        from: Kirigami.Theme.highlightColor
        to: {
            if (displayedPrice === "Err") {
                return Plasmoid.configuration.errorColor || Kirigami.Theme.negativeTextColor;
            }
            return Plasmoid.configuration.textColor || Kirigami.Theme.textColor;
        }
        duration: 1000
    }

    SequentialAnimation {
        id: fadeAnimation
        running: false
        PropertyAnimation { target: combinedText; property: "opacity"; to: 0.0; duration: 500 }
        PropertyAnimation { target: combinedText; property: "opacity"; to: 1.0; duration: 500 }
    }

    Timer {
        id: autoUpdateTimer
        interval: Plasmoid.configuration.timeRefresh * 1000 // Convert from seconds to milliseconds
        repeat: true
        running: true
        onTriggered: {
            curlApi.updatePrice(); // Trigger price update based on configured interval
            if (Plasmoid.configuration.blinkRefresh) {
                fadeAnimation.start();
            }
        }
    }

    spacing: 0 // Remove extra spacing between elements
}
