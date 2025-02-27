// SPDX-FileCopyrightText: 2022 Joshua Goins <josh@redstrate.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

/**
 * @brief An "About KDE" page using Form components.
 *
 * This component consists of a full, internationalized "About KDE" page
 * that can be instantiated directly without passing any properties.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit Kirigami.ScrollablePage
 */
FormCardPage {
    id: page

    title: i18nd("kirigami-addons6", "About KDE")

    FormCard {
        Layout.topMargin: Kirigami.Units.gridUnit

        AbstractFormDelegate {
            id: generalDelegate
            Layout.fillWidth: true
            background: null
            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing * 2

                Kirigami.Icon {
                    Layout.rowSpan: 3
                    Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                    Layout.preferredWidth: height
                    Layout.maximumWidth: page.width / 3;
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    source: "kde"
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        Layout.fillWidth: true
                        text: i18nd("kirigami-addons6", "KDE")
                        wrapMode: Text.WordWrap
                    }

                    Kirigami.Heading {
                        Layout.fillWidth: true
                        level: 3
                        type: Kirigami.Heading.Type.Secondary
                        wrapMode: Text.WordWrap
                        text: i18nd("kirigami-addons6", "Be Free!")
                    }
                }
            }
        }

        FormDelegateSeparator {}

        FormTextDelegate {
            text: i18nd("kirigami-addons6", "KDE is a world-wide community of software engineers, artists, writers, translators and creators who are committed to Free Software development. KDE produces the Plasma desktop environment, hundreds of applications, and the many software libraries that support them.\n\n\
KDE is a cooperative enterprise: no single entity controls its direction or products. Instead, we work together to achieve the common goal of building the world's finest Free Software. Everyone is welcome to join and contribute to KDE, including you.")
            textItem.wrapMode: Text.WordWrap
        }

        FormDelegateSeparator {}

        FormButtonDelegate {
            text: i18nd("kirigami-addons6", "Homepage")
            onClicked: Qt.openUrlExternally("https://kde.org/")
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Report bugs")
    }

    FormCard {
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "Software can always be improved, and the KDE team is ready to do so. However, you - the user - must tell us when something does not work as expected or could be done better.\n\n\
KDE has a bug tracking system. Use the button below to file a bug, or use the program's About page to report a bug specific to this application.\n\n\
If you have a suggestion for improvement then you are welcome to use the bug tracking system to register your wish. Make sure you use the severity called \"Wishlist\".")
            textItem.wrapMode: Text.WordWrap
        }

        FormDelegateSeparator {}

        FormButtonDelegate {
            text: i18nd("kirigami-addons6", "Report a bug")
            onClicked: Qt.openUrlExternally("https://bugs.kde.org/")
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Join us")
    }

    FormCard {
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "You do not have to be a software developer to be a member of the KDE team. You can join the national teams that translate program interfaces. You can provide graphics, themes, sounds, and improved documentation. You decide!")
            textItem.wrapMode: Text.WordWrap
        }

        FormDelegateSeparator { above: getInvolved }

        FormButtonDelegate {
            id: getInvolved
            text: i18nd("kirigami-addons6", "Get Involved")
            onClicked: Qt.openUrlExternally("https://community.kde.org/Get_Involved")
        }

        FormDelegateSeparator { above: devDoc; below: getInvolved }

        FormButtonDelegate {
            id: devDoc
            text: i18nd("kirigami-addons6", "Developer Documentation")
            onClicked: Qt.openUrlExternally("https://develop.kde.org/")
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Support us")
    }

    FormCard {
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "KDE software is and will always be available free of charge, however creating it is not free.\n\n\
To support development the KDE community has formed the KDE e.V., a non-profit organization legally founded in Germany. KDE e.V. represents the KDE community in legal and financial matters.\n\n\
KDE benefits from many kinds of contributions, including financial. We use the funds to reimburse members and others for expenses they incur when contributing. Further funds are used for legal support and organizing conferences and meetings.\n\n\
We would like to encourage you to support our efforts with a financial donation.\n\n\
Thank you very much in advance for your support.")
            textItem.wrapMode: Text.WordWrap
        }

        FormDelegateSeparator { above: ev }

        FormButtonDelegate {
            id: ev
            text: i18nd("kirigami-addons6", "KDE e.V")
            onClicked: Qt.openUrlExternally("https://ev.kde.org/")
        }

        FormDelegateSeparator { above: donate; below: ev }

        FormButtonDelegate {
            id: donate
            text: i18nd("kirigami-addons6", "Donate")
            onClicked: Qt.openUrlExternally("https://www.kde.org/donate")
        }
    }
}
