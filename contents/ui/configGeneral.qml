import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes
import org.kde.kquickcontrols as KQuickControls

KCM.SimpleKCM {
    id: root

    property alias cfg_iconStopped:          stoppedIconPicker.currentIcon
    property alias cfg_isTintStoppedEnabled: stoppedTintPicker.isTinted
    property alias cfg_colorStopped:         stoppedTintPicker.color

    property alias cfg_iconRunning:          runningIconPicker.currentIcon
    property alias cfg_isTintRunningEnabled: runningTintPicker.isTinted
    property alias cfg_colorRunning:         runningTintPicker.color

    property alias cfg_iconActive:          activeIconPicker.currentIcon
    property alias cfg_isTintActiveEnabled: activeTintPicker.isTinted
    property alias cfg_colorActive:         activeTintPicker.color

    property alias cfg_visibility:  visibilityComboBox.currentIndex
    property alias cfg_intervalSec: intervalSpinBox.value

    property string cfg_iconStoppedDefault
    property bool   cfg_isTintStoppedEnabledDefault
    property color  cfg_colorStoppedDefault

    property string cfg_iconRunningDefault
    property bool   cfg_isTintRunningEnabledDefault
    property color  cfg_colorRunningDefault

    property string cfg_iconActiveDefault
    property bool   cfg_isTintActiveEnabledDefault
    property color  cfg_colorActiveDefault

    property int    cfg_visibilityDefault
    property int    cfg_intervalSecDefault

    component IconPicker: RowLayout {
        id: picker

        property string currentIcon
        property string defaultIcon
        readonly property bool isDefault: currentIcon === defaultIcon

        spacing: Kirigami.Units.smallSpacing

        QQC2.Button {
            implicitWidth:  Kirigami.Units.iconSizes.large + Kirigami.Units.largeSpacing * 2
            implicitHeight: implicitWidth

            Accessible.name: i18n("Choose icon")
            onClicked: iconDialog.open()

            Kirigami.Icon {
                anchors.centerIn: parent
                width:  Kirigami.Units.iconSizes.large
                height: width
                source: picker.currentIcon
            }

            KIconThemes.IconDialog {
                id: iconDialog
                onAccepted: picker.currentIcon = iconName
            }
        }

        QQC2.Button {
            icon.name: "edit-reset"
            display:   QQC2.AbstractButton.IconOnly
            text:      i18n("Reset to default")
            enabled:   !picker.isDefault
            onClicked: picker.currentIcon = picker.defaultIcon

            QQC2.ToolTip.text:    text
            QQC2.ToolTip.visible: hovered
            QQC2.ToolTip.delay:   Kirigami.Units.toolTipDelay
        }
    }

    component TintPicker: RowLayout {
        id: tintPicker

        property alias isTinted: tintCheckBox.checked
        property alias color:    colorButton.color

        property color defaultColor
        readonly property bool isDefaultColor: color.toString() === defaultColor.toString()

        spacing: Kirigami.Units.smallSpacing

        QQC2.CheckBox {
            id:   tintCheckBox
            text: i18n("Tint the icon")
        }

        KQuickControls.ColorButton {
            id:      colorButton
            enabled: tintCheckBox.checked
            showAlphaChannel: false
        }

        QQC2.Button {
            icon.name: "edit-reset"
            display:   QQC2.AbstractButton.IconOnly
            text:      i18n("Reset to default")
            enabled:   tintCheckBox.checked && !tintPicker.isDefaultColor
            onClicked: tintPicker.color = tintPicker.defaultColor

            QQC2.ToolTip.text:    text
            QQC2.ToolTip.visible: hovered
            QQC2.ToolTip.delay:   Kirigami.Units.toolTipDelay
        }
    }

    Kirigami.FormLayout {
        IconPicker {
            id: stoppedIconPicker
            Kirigami.FormData.label: i18n("Not running:")
            defaultIcon: root.cfg_iconStoppedDefault
        }

        TintPicker {
            id: stoppedTintPicker
            defaultColor: root.cfg_colorStoppedDefault
        }

        IconPicker {
            id: runningIconPicker
            Kirigami.FormData.label: i18n("Running (idle):")
            defaultIcon: root.cfg_iconRunningDefault
        }

        TintPicker {
            id: runningTintPicker
            defaultColor: root.cfg_colorRunningDefault
        }

        IconPicker {
            id: activeIconPicker
            Kirigami.FormData.label: i18n("Game active:")
            defaultIcon: root.cfg_iconActiveDefault
        }

        TintPicker {
            id: activeTintPicker
            defaultColor: root.cfg_colorActiveDefault
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.ComboBox {
            id: visibilityComboBox
            Kirigami.FormData.label: i18n("Show icon:")
            model: [
                i18n("Always"),
                i18n("While Falcond is running"),
                i18n("While a game is active"),
            ]
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.SpinBox {
            id: intervalSpinBox
            Kirigami.FormData.label: i18n("Check every:")
            from: 1
            to:   60
            textFromValue: (value) => i18n("%1 s", value)
            valueFromText:  (text) => parseInt(text)
        }
    }
}
