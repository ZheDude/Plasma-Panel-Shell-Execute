import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.iconthemes as KIconThemes
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: generalConfigPage

    property string cfg_icon
    property string cfg_iconDefault
    property string cfg_scriptsCommand
    property bool loading: true

    ListModel { id: commandModel }
    
    Connections {
        target: commandModel
        function onRowsInserted() { generalConfigPage.saveList() }
        function onRowsRemoved()  { generalConfigPage.saveList() }
        function onDataChanged()  { generalConfigPage.saveList() }
    }

    // Load once
    Component.onCompleted: {
        try {
            const list = JSON.parse(cfg_scriptsCommand);
            for (const entry of list)
                commandModel.append(entry);
            loading = false;
        } catch (e) {
            loading = false;
        }
    }

    // Serialize the whole model back into the config property
    function saveList() {
        const out = [];
        for (let i = 0; i < commandModel.count; ++i) {
            const e = commandModel.get(i);
            out.push({ label: e.label, iconName: e.iconName, commandString: e.commandString });
        }
        cfg_scriptsCommand = JSON.stringify(out);
    }

    Kirigami.FormLayout {
        id: form
        Layout.fillWidth: true

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Select an Icon"
        }
        RowLayout{
            Item {
                Layout.fillWidth: true
            }
            
            QQC2.Label {
                text: "Icon:"
            }
        
            QQC2.Button {
                icon.name: generalConfigPage.cfg_icon || generalConfigPage.cfg_iconDefault
                text: generalConfigPage.cfg_icon || i18n("Choose…")
                onClicked: iconDialog.open()
            }
            QQC2.ToolButton {
                icon.name: "edit-clear"
                visible: generalConfigPage.cfg_icon !== generalConfigPage.cfg_iconDefault
                onClicked: generalConfigPage.cfg_icon = generalConfigPage.cfg_iconDefault
                QQC2.ToolTip.text: i18n("Reset to default")
                QQC2.ToolTip.visible: hovered
            }
            Item {
                Layout.fillWidth: true
            }
        }

        KIconThemes.IconDialog {
            id: iconDialog
            onIconNameChanged: iconName => generalConfigPage.cfg_icon = iconName
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Scripts"
        }

        property var commandList: []
        
        ColumnLayout {
            Repeater {
                model: commandModel
                delegate: RowLayout {
                    required property int index
                    required property string label
                    required property string commandString
                    QQC2.TextField {
                        text: label
                        placeholderText: "Label"
                        onTextEdited: {
                            commandModel.setProperty(index, "label", text);
                        }
                    }
                    QQC2.TextField {
                        text: commandString
                        placeholderText: "Command"
                        onTextEdited: {
                            commandModel.setProperty(index, "commandString", text);
                        }
                    }
                    QQC2.ToolButton {
                        icon.name: "list-remove"
                        onClicked: {
                            commandModel.remove(index);
                        }
                    }
                }
            }
            QQC2.Button {
                text: "Add Entry"
                icon.name: "list-add"
                onClicked: {
                    commandModel.append({ label: "", iconName: "document-save", commandString: "" });
                }
            }
        }
    }
}