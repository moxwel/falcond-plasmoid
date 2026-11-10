import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property string statusFile: "/tmp/falcond_status"

    readonly property string statusCommand: "sh -c \"systemctl show -p LoadState --value falcond; systemctl is-active falcond; sed -n 's/^ACTIVE_PROFILE: //p' " + statusFile + "\" 2>/dev/null"

    property bool   isFalcondInstalled: true // assume installed until we check
    property bool   isFalcondRunning:   false
    property string activeProfile: ""

    readonly property bool isProfileActive: isFalcondRunning && activeProfile !== "" && activeProfile !== "None"
    readonly property bool isInEditMode:    Plasmoid.containment?.corona?.editMode ?? false

    readonly property int visibilityAlwaysShown: 0
    readonly property int visibilityWhenRunning: 1
    readonly property int visibilityWhenActive:  2

    readonly property int  visibilityMode:       Plasmoid.configuration.visibility
    readonly property bool isHiddenUntilRunning: visibilityMode === visibilityWhenRunning && !isFalcondRunning
    readonly property bool isHiddenUntilActive:  visibilityMode === visibilityWhenActive  && !isProfileActive
    readonly property bool shouldHide: (isHiddenUntilRunning || isHiddenUntilActive) && !isInEditMode

    readonly property string iconName: {
        if (!isFalcondInstalled) return Plasmoid.configuration.iconNotInstalled;
        if (isProfileActive)     return Plasmoid.configuration.iconActive;
        if (isFalcondRunning)    return Plasmoid.configuration.iconRunning;
        return Plasmoid.configuration.iconStopped;
    }
    readonly property color iconColor: {
        if (!isFalcondInstalled) return Plasmoid.configuration.colorNotInstalled;
        if (isProfileActive)     return Plasmoid.configuration.colorActive;
        if (isFalcondRunning)    return Plasmoid.configuration.colorRunning;
        return Plasmoid.configuration.colorStopped;
    }
    readonly property bool isTinted: {
        if (!isFalcondInstalled) return Plasmoid.configuration.isTintNotInstalledEnabled;
        if (isProfileActive)     return Plasmoid.configuration.isTintActiveEnabled;
        if (isFalcondRunning)    return Plasmoid.configuration.isTintRunningEnabled;
        return Plasmoid.configuration.isTintStoppedEnabled;
    }
    readonly property string statusText: {
        if (!isFalcondInstalled) return i18n("Not installed");
        if (isProfileActive)     return i18n("Game active (%1)", activeProfile);
        if (isFalcondRunning)    return i18n("Running (idle)");
        return i18n("Not running");
    }

    // "Shown when relevant" hides until a game is active
    readonly property int visibleStatus: isProfileActive ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    Plasmoid.status: shouldHide ? PlasmaCore.Types.HiddenStatus : visibleStatus

    Plasma5Support.DataSource {
        engine: "executable"
        connectedSources: [root.statusCommand]
        interval: Plasmoid.configuration.intervalSec * 1000
        onNewData: (source, data) => {
            const lines = (data.stdout || "").trim().split("\n");
            root.isFalcondInstalled = lines[0] !== "not-found";
            root.isFalcondRunning   = lines[1] === "active";
            root.activeProfile      = lines[2] ||  "";
        }
    }

    preferredRepresentation:   compactRepresentation
    activationTogglesExpanded: false
    fullRepresentation:        Item {} // no popup

    toolTipMainText: Plasmoid.title
    toolTipSubText:  statusText

    compactRepresentation: Component {
        Kirigami.Icon {
            readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

            Layout.preferredWidth:  isVertical ? width : height
            Layout.preferredHeight: isVertical ? width : height

            source: root.iconName

            // the color only applies to a masked icon
            isMask: root.isTinted
            color:  root.iconColor

            Accessible.name:        Plasmoid.title
            Accessible.description: root.statusText
            Accessible.role:        Accessible.Indicator
        }
    }
}
