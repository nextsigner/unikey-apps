import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0

//import ZipManager 4.0


ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: 'black'
    title: 'Unikey Apps'
    property int fs: Screen.width*0.02
    Item{
        id: xApp
        anchors.fill: parent
        Column{
            anchors.centerIn: parent
            spacing: app.fs*0.5
            T{
             text: '<h1>UniKey Apps</h1>'
            }
            T{
             text: '<h4>Lista en construcción</h4>'
            }
        }

    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
}
