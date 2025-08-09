import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.11
import org.kde.kirigami as Kirigami

Item {
    id: configRoot

    signal configurationChanged

    property alias cfg_fontSize: fontsizedefault.value
    property alias cfg_textBold: boldTextCkeck.checked
    property alias cfg_cryptoCurrency: cryptoCurrencyField.text
    property alias cfg_fiatCurrency: fiatCurrencyField.text
    property alias cfg_showCurrencyName: showCurrencyNameCheckBox.checked
    property alias cfg_decimalPlaces: decimalPlacesSpinBox.value
    property alias cfg_priceMultiplier: priceMultiplierField.text
    property alias cfg_useThousandsSeparator: thousandsSeparatorCheckBox.checked
    property alias cfg_swapCommasDots: swapCommasDotsCheckBox.checked
    property alias cfg_textColor: textColorField.text
    property alias cfg_timeRefresh: timeRefreshSpinBox.value
    property alias cfg_blinkRefresh: blinkRefreshCheckBox.checked

    Component.onCompleted: {
        cryptoCurrencyField.text = Plasmoid.configuration.cryptoCurrency || "BTC"
        fiatCurrencyField.text = Plasmoid.configuration.fiatCurrency || "USD"
    }

    ScrollView {
        width: parent.width
        height: parent.height

        ColumnLayout {
            Layout.preferredWidth: parent.width - Kirigami.Units.largeSpacing * 2
            Layout.minimumWidth: preferredWidth
            Layout.maximumWidth: preferredWidth
            spacing: Kirigami.Units.smallSpacing * 3

            GridLayout {
                Layout.preferredWidth: parent.width
                Layout.minimumWidth: preferredWidth
                Layout.maximumWidth: preferredWidth
                columns: 2

                // Font size
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Font Size for Price:")
                    horizontalAlignment: Label.AlignRight
                }
                SpinBox {
                    from: 5
                    id: fontsizedefault
                    to: 40
                }

                // Bold text
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Bold:")
                    horizontalAlignment: Label.AlignRight
                }
                CheckBox {
                    id: boldTextCkeck
                    text: i18n("")
                }

                // Crypto Currency
                Item {
                    Layout.minimumWidth: root.width / 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    RowLayout {
                        anchors.fill: parent
                        spacing: 2

                        Label {
                            text: i18n("Cryptocurrency:")
                            horizontalAlignment: Label.AlignRight
                            verticalAlignment: Label.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            Layout.fillWidth: true
                        }
                    }
                }
                TextField {
                    id: cryptoCurrencyField
                    text: "BTC"
                    placeholderText: "BTC"

                    onTextChanged: {
                        var upperText = text.toUpperCase();
                        
                        // Allow intermediate typing, only validate on focus lost or when complete
                        if (upperText.length <= 10 && /^[A-Z0-9]*$/.test(upperText)) {
                            text = upperText;
                            if (upperText.length >= 1) {
                                Plasmoid.configuration.cryptoCurrency = text;
                                configurationChanged();
                            }
                        } else if (upperText.length > 10) {
                            text = text.substring(0, 10).toUpperCase();
                        } else {
                            // Remove invalid characters
                            text = text.replace(/[^A-Z0-9]/g, '');
                        }
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Cryptocurrency symbol like ETH, BTC, LTC, DOGE, etc. Only uppercase letters and numbers allowed. 1-10 characters.")
                }

                // Fiat Currency
                Item {
                    Layout.minimumWidth: root.width / 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    RowLayout {
                        anchors.fill: parent
                        spacing: 2

                        Label {
                            text: i18n("Fiat Currency:")
                            horizontalAlignment: Label.AlignRight
                            verticalAlignment: Label.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            Layout.fillWidth: true
                        }
                    }
                }
                TextField {
                    id: fiatCurrencyField
                    text: "USD"
                    placeholderText: "USD"

                    onTextChanged: {
                        var upperText = text.toUpperCase();
                        
                        // Allow intermediate typing, only validate when complete
                        if (upperText.length <= 3 && /^[A-Z]*$/.test(upperText)) {
                            text = upperText;
                            if (upperText.length === 3) {
                                Plasmoid.configuration.fiatCurrency = text;
                                configurationChanged();
                            }
                        } else if (upperText.length > 3) {
                            text = text.substring(0, 3).toUpperCase();
                        } else {
                            // Remove invalid characters
                            text = text.replace(/[^A-Z]/g, '');
                        }
                    }
                    
                    onEditingFinished: {
                        if (text.length === 3) {
                            Plasmoid.configuration.fiatCurrency = text;
                            configurationChanged();
                        }
                    }
                    
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Fiat currency code like USD, EUR, INR, GBP, JPY, etc. Must be exactly 3 letter ISO code.")
                }

                // Show Currency Name
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Show Currency Pair")
                    horizontalAlignment: Label.AlignRight
                }
                CheckBox {
                    id: showCurrencyNameCheckBox
                    text: i18n("")
                    checked: true
                }

                // Decimal Places
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Decimal Places:")
                    horizontalAlignment: Label.AlignRight
                }
                SpinBox {
                    id: decimalPlacesSpinBox
                    from: 0
                    to: 10
                    value: 3
                    stepSize: 1
                    onValueChanged: configurationChanged()
                }

                // Price Multiplier with tooltip
                Item {
                    Layout.minimumWidth: root.width / 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    RowLayout {
                        anchors.fill: parent
                        spacing: 2

                        Label {
                            text: i18n("Price Multiplier:")
                            horizontalAlignment: Label.AlignRight
                            verticalAlignment: Label.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            Layout.fillWidth: true
                        }
                    }
                }

                TextField {
                    id: priceMultiplierField
                    text: "1"
                    onTextChanged: {
                        // Check for 4 decimal places
                        var regex = /^[0-9]*\.?[0-9]{0,4}$/;
                        if (!regex.test(priceMultiplierField.text)) {
                            priceMultiplierField.text = priceMultiplierField.text.slice(0, -1);
                        }
                        configurationChanged()
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Multiply the price by this value. Use only numbers (e.g., 1.3812). Max 4 decimal places. Default: 1. An asterisk will be placed next to the currency pair to symbolize the use of this feature.")
                }

                // Thousands Separator
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Thousands Separator:")
                    horizontalAlignment: Label.AlignRight
                }
                CheckBox {
                    id: thousandsSeparatorCheckBox
                    text: i18n("")
                    checked: false
                    onCheckedChanged: configurationChanged()
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Format numbers with a thousands separator (e.g., 1,000.23).")
                }

                // Swap commas-dots
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Swap commas-dots:")
                    horizontalAlignment: Label.AlignRight
                }
                CheckBox {
                    id: swapCommasDotsCheckBox
                    text: i18n("")
                    checked: cfg_swapCommasDots
                    onCheckedChanged: {
                        configurationChanged()
                        cfg_swapCommasDots = checked
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Swap commas for dots and vice-versa to match usage in each country.")
                }

                // Text Color
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Text Color:")
                    horizontalAlignment: Label.AlignRight
                }
                TextField {
                    id: textColorField
                    text: "#000000"
                    onTextChanged: configurationChanged()
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Use color names (red, yellowgreen) or HEX code (#ffff00 for yellow). Leave empty to use the theme's default color.")
                }

                // Time Refresh
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Time Refresh (seconds):")
                    horizontalAlignment: Label.AlignRight
                }
                SpinBox {
                    id: timeRefreshSpinBox
                    from: 1
                    to: 300
                    value: 5
                    stepSize: 1
                    onValueChanged: configurationChanged()
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Seconds to refresh the price. Valid range: 1–300 (5 minutes).")
                }

                // Blink Refresh
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("Blink Refresh:")
                    horizontalAlignment: Label.AlignRight
                }
                CheckBox {
                    id: blinkRefreshCheckBox
                    text: i18n("")
                    checked: false
                    onCheckedChanged: configurationChanged()
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Blink the price when it refreshes.")
                }

                // Applet version
                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("CryptoStats version:")
                    horizontalAlignment: Label.AlignRight
                }

                Label {
                    Layout.minimumWidth: root.width / 2
                    text: i18n("3.0    (2025-08-08)")
                }

            }  // Closing GridLayout
        }      // Closing ColumnLayout
    }          // Closing ScrollView
}              // Closing Item
