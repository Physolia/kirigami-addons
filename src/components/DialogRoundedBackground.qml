// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import org.kde.kirigami 2.20 as Kirigami

/**
 * @brief Stylish background for dialogs
 *
 * This item can be used as background for any dialog in your application
 * and will provide a rounded.
 *
 * @since KirigamiAddons 0.12
 */
Kirigami.ShadowedRectangle {
    radius: Kirigami.Units.largeSpacing
    color: Kirigami.Theme.backgroundColor

    border {
        width: 1
        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);
    }

    shadow {
        size: Kirigami.Units.gridUnit
        yOffset: 0
        color: Qt.rgba(0, 0, 0, 0.2)
    }

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.View
}
