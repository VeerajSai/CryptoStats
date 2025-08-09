import QtQuick 2.12
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    fullRepresentation: CompactRepresentation {
        id: compactRepresentation
        anchors.fill: parent
    }
}
