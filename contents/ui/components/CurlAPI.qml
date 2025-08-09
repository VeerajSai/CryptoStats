import QtQuick
import org.kde.plasma.plasmoid

Item {
    property string cryptoCurrency: "BTC"
    property string fiatCurrency: "USD"
    property int decimalPlaces: 3
    property int refreshRate: Plasmoid.configuration.timeRefresh || 5 // Refresh rate in seconds
    property var price: null
    property bool inErrorState: false
    property real priceMultiplier: 1.0

    onCryptoCurrencyChanged: updatePrice()
    onFiatCurrencyChanged: updatePrice()
    onPriceMultiplierChanged: updatePrice()

    function updatePrice() {
        if (!cryptoCurrency || cryptoCurrency === "" || !fiatCurrency || fiatCurrency === "")
            return;

        console.log("CryptoStats: Fetching", cryptoCurrency + "/" + fiatCurrency, "with multiplier", priceMultiplier);
        
        // Use XMLHttpRequest with enhanced processing that mimics the curl pipeline
        const url = "https://api.coinbase.com/v2/exchange-rates?currency=" + cryptoCurrency;
        executeAPICall(url);
    }

    function executeAPICall(url) {
        const req = new XMLHttpRequest();
        req.open("GET", url, true);

        req.onreadystatechange = function () {
            if (req.readyState !== 4) return;

            if (req.status === 200) {
                try {
                    const data = JSON.parse(req.responseText);
                    if (data && data.data && data.data.rates && data.data.rates[fiatCurrency]) {
                        // Mimic the jq pipeline: .data.rates.FIAT | tonumber | . * MULTIPLIER | @text
                        const rate = parseFloat(data.data.rates[fiatCurrency]);
                        if (!isNaN(rate)) {
                            const finalPrice = rate * priceMultiplier;
                            // Format exactly like printf "%.{decimalPlaces}f"
                            price = parseFloat(finalPrice.toFixed(decimalPlaces));
                            inErrorState = false;
                            console.log("CryptoStats: Price updated:", cryptoCurrency + "/" + fiatCurrency, "=", price);
                        } else {
                            console.error("CryptoStats: Invalid rate value for", fiatCurrency);
                            price = "E";
                            inErrorState = true;
                            retry.start();
                        }
                    } else {
                        console.error("CryptoStats: No rate found for", fiatCurrency, "in response");
                        console.error("CryptoStats: Available rates:", data?.data?.rates ? Object.keys(data.data.rates).slice(0, 10).join(", ") + "..." : "none");
                        price = "E";
                        inErrorState = true;
                        retry.start();
                    }
                } catch (e) {
                    console.error("CryptoStats: Error parsing API response:", e);
                    price = "E";
                    inErrorState = true;
                    retry.start();
                }
            } else {
                console.error(`CryptoStats: HTTP error ${req.status}: ${req.statusText}`);
                price = "E";
                inErrorState = true;
                retry.start();
            }
        };

        req.send();
    }

    Timer {
        id: retry
        interval: 30000 // Retry after 30 seconds
        repeat: false
        running: false
        onTriggered: updatePrice()
    }

    Timer {
        id: updateTimer
        interval: refreshRate * 1000 // Convert from seconds to milliseconds
        repeat: true
        running: true
        onTriggered: updatePrice()
    }

    Component.onCompleted: updatePrice()
}
