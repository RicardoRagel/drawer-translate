#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>
#include <QClipboard>
#include <QApplication>

#include "Constants.h"

using namespace std;

class DataManager : public QObject
{
  Q_OBJECT

public:

  // Constructor
  DataManager();

  // Destuctor
  ~DataManager();

  // QML properties declarations
  Q_PROPERTY(QString inputText READ inputText WRITE setInputText NOTIFY inputTextChanged)

  // QML properties getters
  QString inputText() {return _input_text;}

  // QML Invokable properties setters
  Q_INVOKABLE void setInputText(QString input_text);

signals:

  // QML properties signals
  void inputTextChanged();

private slots:

  // Receive selection changes
  void clipboardDataChanged();
  void clipboardSelectionChanged();

private:

  // Variables
  QString _input_text;
  QClipboard *_clipboard;
};

#endif // DATAMANAGER_H
