import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.iconthemes as KIconThemes

Kirigami.FormLayout {
    id: page

    property alias cfg_icon: icon.text

    Kirigami.Heading {
        text: "Select an Icon"
    }

    RowLayout {
        Kirigami.FormData.label: "Icon:"

        QQC2.TextField {
            id: icon
            implicitWidth: 300
        }

        QQC2.Button {
            icon.name: "folder"
            onClicked: {
                iconDialog.open();
            }
        }
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    KIconThemes.IconDialog {
        id: iconDialog

        onIconNameChanged: iconName => {
            page.cfg_icon = iconName;
        }
    }
}
