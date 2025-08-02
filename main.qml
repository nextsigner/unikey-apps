import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.1
import UniKeyZipDownloader 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: 'black'
    title: 'Unikey Apps'
    property int fs: Screen.width*0.02
    Settings{
        id: apps
        fileName: unik.getPath(4)+'/'+(''+presetAppName).toLowerCase()+'_app.cfg'
        property bool dev: false
        property bool dep: true
        property string mainFolder: ''
        property bool runFromGit: false
        property string uGitRep: 'https://github.com/nextsigner/unikey-apps'
        property string uFolder: unik?unik.getPath(3):''
        property bool enableCheckBoxShowGitRep: false
        property color fontColor: 'white'
        property color backgroundColor: 'black'
        property string uCtxUpdate: ''
    }
    Item{
        id: xApp
        anchors.fill: parent
        Column{
            anchors.centerIn: parent
            spacing: app.fs*0.5
            T{
                text: '<h3>UniKey Apps</h3>'
            }
            Rectangle{
                width: xApp.width-app.fs
                height: xApp.height-app.fs*10
                color: 'transparent'
                border.width: 1
                border.color: 'white'
                clip: true
                ListView{
                    id: lv
                    anchors.fill: parent
                    model: lm
                    delegate: lvItem
                    ListModel{
                        id: lm
                        function add(text, des, url){
                            return{
                                t: text,
                                u: url,
                                d: des
                            }
                        }
                    }
                }
            }
        }

    }
    Component{
        id: lvItem
        Rectangle{
            id: xItem
            width: lv.width-app.fs
            height: col1.height+app.fs
            color: 'transparent'
            border.width: 1
            border.color: 'white'
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Column{
                id: col1
                anchors.centerIn: parent
                Row{
                    id: row1
                    spacing: app.fs*0.5
                    T{
                        id: txt1
                        text: t
                        color: 'black'
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle{
                            width: parent.width+4
                            height: parent.height+4
                            color: 'white'
                            anchors.centerIn: parent
                            z: parent.z-1
                        }

                    }
                    T{
                        id: txtDes
                        text: '<b>Descripción: </b> '+d
                        width: xItem.width-txt1.contentWidth-rowBtns.width-app.fs*2
                        font.pixelSize: app.fs*0.5
                        wrapMode: Text.WordWrap
                        anchors.verticalCenter: parent.verticalCenter

                    }
                    Row{
                        id: rowBtns
                        spacing: app.fs*0.25
                        Button{
                            id: botLaunch
                            text: 'Lanzar'
                            anchors.verticalCenter: parent.verticalCenter
                            property string folder: ''
                            visible: folder!==''
                            onClicked: {
                                let mainPath='"'+folder.replace(/\"/g, '')+'"'
                                let args=[]
                                args.push('-folder='+""+mainPath.replace(/\"/g, ''))
                                unik.restart(args, ""+mainPath.replace(/\"/g, ''))
                                app.close()
                            }
                        }
                        Button{
                            id: botInstalar
                            text: 'Instalar'
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: run(u, t)
                        }
                    }
                }
                Column{
                    id: colZM
                    width: parent.width
                }
            }
            Component.onCompleted: {
                let m0=u.split('/')
                let projectName=m0[m0.length-1]
                let folderApp=unik.getPath(4)+'/'+projectName+'/'+projectName+'-main'
                if(unik.folderExist(folderApp)){
                    botInstalar.text='Reinstalar'
                    botLaunch.folder=folderApp
                }
            }
        }
    }
    UniKeyZipDownloader{
        id: uzd
        width: parent.width
        visible: true
    }
    Component.onCompleted: {
        lm.append(lm.add('Zool', 'Aplicación de Astrología desarrollada por Ricardo Martín Pizarro', 'https://github.com/nextsigner/zoolv4'))
        lm.append(lm.add('UniKey Ejemplo Sqlite', 'Aplicación de ejemplo para utilizar bases de datos SQLITE en UniKey', 'https://github.com/nextsigner/unikey-ejemplo-sqlite'))
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(uzd.zm.cPorc>=0.01){
               uzd.zm.cancelar()
                return
            }
            if(uzd.visible){
               uzd.visible=false
                return
            }
            Qt.quit()
        }
    }
    function run(url, appName){
        uzd.title='<h3>'+appName+'</h3>'
        //uzd.zm.resetApp=true
        //uzd.zm.setCfg=true
        uzd.zm.download(url)
    }
}
