import QtQuick
import org.kde.plasma.plasmoid

Item {
    property string cryptoCurrency: "ETH"
    property string fiatCurrency: "INR"
    property int decimalPlaces: 3
    property int refreshRate: Plasmoid.configuration.timeRefresh || 3 // Refresh rate in minutes
    property var price: null // Set no initial price
    property bool inErrorState: false
    property real priceMultiplier: 1.0

    onCryptoCurrencyChanged: updatePrice()
    onFiatCurrencyChanged: updatePrice()
    onPriceMultiplierChanged: updatePrice()

    function updatePrice() {
        if (!cryptoCurrency || cryptoCurrency === "" || !fiatCurrency || fiatCurrency === "")
            return;

        // Use XMLHttpRequest as primary method (more reliable in QML)
        const url = "https://api.coinbase.com/v2/exchange-rates?currency=" + cryptoCurrency;
        updateAPI(url);
    }

    function updateAPI(url) {
        const req = new XMLHttpRequest();
        req.open("GET", url, true);

        req.onreadystatechange = function () {
            if (req.readyState !== 4) return;

            if (req.status === 200) {
                try {
                    const data = JSON.parse(req.responseText);
                    if (data && data.data && data.data.rates && data.data.rates[fiatCurrency]) {
                        const rate = parseFloat(data.data.rates[fiatCurrency]);
                        const finalPrice = rate * priceMultiplier;
                        price = parseFloat(finalPrice.toFixed(decimalPlaces));
                        inErrorState = false;
                        console.log("AP6CM: Price updated:", cryptoCurrency + "/" + fiatCurrency, "=", price);
                    } else {
                        // If no valid price data, set as error state
                        console.error("AP6CM: No rate found for", fiatCurrency, "in response");
                        price = "E";
                        inErrorState = true;
                        retry.start();
                    }
                } catch (e) {
                    console.error("AP6CM: Error parsing API response:", e);
                    price = "E"; // Use 'E' to indicate error
                    inErrorState = true;
                    retry.start(); // Retry if parsing fails
                }
            } else {
                console.error(`AP6CM: Query failed with status: ${req.status}`);
                price = "E"; // Use 'E' to indicate HTTP error
                inErrorState = true;
                retry.start(); // Retry on error
            }
        };

        req.send();
    }

    Timer {
        id: retry
        interval: 60000 // Retry after 60 seconds
        repeat: false
        running: false
        onTriggered: updatePrice()
    }

    Timer {
        id: updateTimer
        interval: refreshRate * 60000 // Convert from minutes to milliseconds
        repeat: true
        running: true
        onTriggered: updatePrice()
    }

    Component.onCompleted: updatePrice()
}
