import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0

import ZipManager 1.0

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
                        text: '<b>Descripción: </b> '+d
                        width: xItem.width-txt1.contentWidth-botInstalar.width-app.fs*2
                        font.pixelSize: app.fs*0.5
                        wrapMode: Text.WordWrap
                        anchors.verticalCenter: parent.verticalCenter

                    }
                    Button{
                        id: botInstalar
                        text: 'Instalar'
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: run(u, colZM)
                    }
                }
                Column{
                    id: colZM
                    width: parent.width
                }
            }
        }
        ZipManager{
            id: zipManager
            width: parent.width
            parent: apps.dev?colZM:colSplash
            visible: parent!==xApp
            dev: false
            onResponseRepExist:{
                if(res.indexOf('404')>=0){
                    tiGitRep.color='red'
                    log.lv('El repositorio ['+url+'] no existe.')
                }else{
                    tiGitRep.color=apps.fontColor
                    log.lv('El repositorio ['+url+'] está disponible en internet.')
                    log.lv('Para probarlo presiona ENTER')
                    log.lv('Para instalarlo presiona Ctrl+ENTER')
                }
            }
            onResponseRepVersion:{
                procRRV(res, url, tipo)
            }
        }

    }
    Component.onCompleted: {
        lm.append(lm.add('Zool', 'Aplicación de Astrología desarrollada por Ricardo Martín Pizarro', 'https://github.com/nextsigner/zoolv4'))
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    function run(url, parent){
        zipManager.parent=parent
        zipManager.mkUqpRepVersion(url, 'install')

//        let aname=(''+presetAppName).toLowerCase()
//        let cfgPath='"'+unik.getPath(4)+'/'+aname+'.cfg"'
//        let j={}
//        j.args={}
//        j.args['git']=url
    }
    }
