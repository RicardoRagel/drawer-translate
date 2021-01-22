#include "DataManager.h"
#include <QJsonObject>

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

DataManager::DataManager()
{

  qDebug() << "(DataManager) Initialization ...";
}

DataManager::~DataManager()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void DataManager::setInputText(QString input_text)
{
    //qDebug() << "(DataManager) Input Text: " << input_text;

    _input_text = input_text;
    emit inputTextChanged();
}

/** *********************************
 *  QML Invokable standalone functions
 ** ********************************/
//void DataManager::clearList()
//{
//    _item_list.clear();
//    updateQmlItemList();
//}

/** *********************************
 *  Auxiliar functions
 ** ********************************/
//void DataManager::loadListFromJson(QJsonDocument doc)
//{
//    //qDebug() << doc.toJson();
//    QJsonArray objs_array = doc.array();
//    qDebug() << "Loading " << objs_array.size() << " elements";

//    for(const auto value : objs_array)
//    {
//        QJsonObject obj = value.toObject();
//        addItem(obj["id"].toInt(), obj["name"].toString(), obj["checked"].toBool(), obj["score"].toDouble(), obj["filepath"].toString());
//    }
//}
