// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1 as DateTime
import org.kde.kirigamiaddons.components 1.0 as Components

/**
 * @brief A Form delegate containing a date and time selector.
 * @since KirigamiAddons 0.12.0
 */
AbstractFormDelegate {
    id: root

    /**
     * Enum containing the different part of the date time that can be displayed.
     */
    enum DateTimeDisplay {
        DateTime, /** Show the date and time */
        Date, /** Show only the date */
        Time /** Show only the time */
    }

    /**
     * This property holds which part of the date and time selector are show to the
     * user.
     *
     * By default both the time and the date are shown.
     */
    property int dateTimeDisplay: FormDateTimeDelegate.DateTimeDisplay.DateTime

    /**
     * This property holds the minimum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property var minimumDate: null

    /**
     * This property holds the maximum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property var maximumDate: null

    /**
     * This property holds whether this delegate is readOnly or whether the user
     * can select a new time and date.
     */
    property bool readOnly: false

    /**
     * @brief The current date and time selected by the user.
     */
    property date value: new Date()

    background: null

    focusPolicy: text.length > 0 ? Qt.TabFocus : Qt.NoFocus

    padding: 0
    topPadding: undefined
    leftPadding: undefined
    rightPadding: undefined
    bottomPadding: undefined
    verticalPadding: undefined
    horizontalPadding: undefined

    contentItem: ColumnLayout {
        spacing: 0

        QQC2.Label {
            text: root.text
            Layout.fillWidth: true
            padding: Kirigami.Units.gridUnit
            bottomPadding: Kirigami.Units.largeSpacing
            topPadding: Kirigami.Units.largeSpacing
            visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime
        }

        RowLayout {
            spacing: 0

            Layout.fillWidth: true
            Layout.minimumWidth: parent.width

            QQC2.AbstractButton {
                id: dateButton

                horizontalPadding: Kirigami.Units.gridUnit
                verticalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

                Layout.fillWidth: true
                Layout.maximumWidth: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime ? parent.width / 2 : parent.width

                visible: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime || root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Date

                text: if (!isNaN(root.value.valueOf())) {
                    const today = new Date();
                    if (root.value.getYear() === today.getYear()
                        && root.value.getDate() === today.getDate()
                        && root.value.getMonth() == today.getMonth()) {
                        return i18ndc("kirigami-addons", "Displayed in place of the date if the selected day is today", "Today");
                    }
                    const locale = Qt.locale();
                    const weekDay = root.value.toLocaleDateString(locale, "ddd, ");
                    if (root.value.getYear() == today.getYear(Locale.ShortFormat)) {
                        return weekDay + root.value.toLocaleDateString(locale, Locale.ShortFormat);
                    }

                    const escapeRegExp = (strToEscape) => {
                        // Escape special characters for use in a regular expression
                        return strToEscape.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
                    };

                    const trimChar = (origString, charToTrim) => {
                        charToTrim = escapeRegExp(charToTrim);
                        const regEx = new RegExp("^[" + charToTrim + "]+|[" + charToTrim + "]+$", "g");
                        return origString.replace(regEx, "");
                    };

                    let dateFormat = locale.dateFormat(Locale.ShortFormat)
                        .replace(root.value.getYear(), '')
                        .replace('yyyy', ''); // I'll be long dead when this will break and this won't be my problem anymore

                    dateFormat = trimChar(trimChar(trimChar(dateFormat, '-'), '.'), '/')

                    return weekDay + root.value.toLocaleDateString(locale, dateFormat);
                } else {
                    i18ndc("kirigami-addons", "Date is not set", "Not set")
                }

                contentItem: RowLayout {
                    Kirigami.Icon {
                        source: "view-calendar"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium 
                    }

                    QQC2.Label {
                        id: dateLabel

                        text: root.text
                        Layout.fillWidth: true
                        padding: Kirigami.Units.gridUnit
                        bottomPadding: Kirigami.Units.largeSpacing
                        topPadding: Kirigami.Units.largeSpacing
                        visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Date
                    }

                    QQC2.Label {
                        text: dateButton.text

                        Layout.fillWidth: !dateLabel.visible
                    }
                }
                onClicked: {
                    if (root.readOnly) {
                        return;
                    }

                    let value = root.value;

                    if (!value) {
                        value = new Date();
                    }

                    if (root.minimumDate) {
                        root.minimumDate.setHours(0, 0, 0, 0);
                    }
                    if (root.maximumDate) {
                        root.maximumDate.setHours(0, 0, 0, 0);
                    }

                    const item = datePopup.createObject(applicationWindow(), {
                        value: value,
                        minimumDate: root.minimumDate,
                        maximumDate: root.maximumDate,
                    });

                    item.accepted.connect(() => {
                        root.value.setDate(item.value.getDate());
                        root.value.setMonth(item.value.getMonth());
                        root.value.setYear(item.value.getYear());
                    });

                    item.open();
                }

                background: FormDelegateBackground {
                    visible: !root.readOnly
                    control: dateButton
                }

                Component {
                    id: datePopup
                    DateTime.DatePopup {
                        x: parent ? Math.round((parent.width - width) / 2) : 0
                        y: parent ? Math.round((parent.height - height) / 2) : 0

                        width: Math.min(Kirigami.Units.gridUnit * 20, applicationWindow().width - 2 * Kirigami.Units.gridUnit)

                        height: Kirigami.Units.gridUnit * 20

                        modal: true

                        onClosed: destroy();
                    }
                }
            }

            Kirigami.Separator {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: dateButton.hovered || timeButton.hovered ? 0 : 0.5
            }

            QQC2.AbstractButton {
                id: timeButton

                property bool androidPickerActive: false

                visible: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime || root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Time

                horizontalPadding: Kirigami.Units.gridUnit
                verticalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

                Layout.fillWidth: true
                Layout.maximumWidth: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime ? parent.width / 2 : parent.width

                text: if (!isNaN(root.value.valueOf())) {
                    const locale = Qt.locale();
                    const timeFormat = locale.timeFormat(Locale.ShortFormat)
                        .replace(':ss', '');
                    root.value.toLocaleTimeString(locale, timeFormat);
                } else {
                    i18ndc("kirigami-addons", "Date is not set", "Not set")
                }

                onClicked: {
                    if (root.readOnly) {
                        return;
                    }

                    if (Qt.platform.os === 'android') {
                        androidPickerActive = true;
                        DateTime.AndroidIntegration.showTimePicker(timeInput.value.getTime());
                    } else {
                        const popup = timePopup.createObject(applicationWindow(), {
                            value: root.value,
                        })
                        popup.open();
                    }
                }

                Component {
                    id: timePopup
                    QQC2.Dialog {
                        id: popup

                        x: parent ? Math.round((parent.width - width) / 2) : 0
                        y: parent ? Math.round((parent.height - height) / 2) : 0

                        modal: true

                        property date value

                        onValueChanged: () => {
                            root.value.setHours(popup.value.getHours(), popup.value.getMinutes());
                        }

                        onClosed: popup.destroy();

                        contentItem: DateTime.TumblerTimePicker {
                            id: popupContent
                            implicitWidth: applicationWindow().width
                            minutes: popup.value.getMinutes()
                            hours: popup.value.getHours()
                            onMinutesChanged: {
                                popup.value.setHours(hours, minutes);
                            }
                            onHoursChanged: {
                                popup.value.setHours(hours, minutes);
                            }
                        }


                        background: Components.DialogRoundedBackground {}
                    }
                }

                Connections {
                    enabled: Qt.platform.os === 'android' && timeButton.androidPickerActive
                    ignoreUnknownSignals: !enabled
                    target: enabled ? DateTime.AndroidIntegration : null
                    function onTimePickerFinished(accepted, newDate) {
                        timeButton.androidPickerActive = false;
                        if (accepted) {
                            timeInput.value = newDate;
                            root.value.setHours(newDate.getHours(), newDate.getMinutes());
                        }
                    }
                }

                contentItem: RowLayout {
                    Kirigami.Icon {
                        source: "clock"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium 
                    }

                    QQC2.Label {
                        id: timeLabel
                        text: root.text
                        Layout.fillWidth: true
                        padding: Kirigami.Units.gridUnit
                        bottomPadding: Kirigami.Units.largeSpacing
                        topPadding: Kirigami.Units.largeSpacing
                        visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Time
                    }

                    QQC2.Label {
                        text: timeButton.text
                        Layout.fillWidth: !timeLabel.visible
                    }
                }

                background: FormDelegateBackground {
                    control: timeButton
                    visible: !root.readOnly
                }
            }
        }
    }
}
