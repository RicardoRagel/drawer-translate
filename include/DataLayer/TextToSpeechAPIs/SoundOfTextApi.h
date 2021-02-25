#ifndef SOUNDOFTEXTAPI_H
#define SOUNDOFTEXTAPI_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QUrlQuery>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

/* Sound of Text API steps:
 *
 * 1. Send POST request to start the synthesis:
 *    curl -X POST "https://api.soundoftext.com/sounds" -H  "accept: application/json" -H  "Content-Type: application/json" -d @request.json
 *    where request.json is a file that contains the request information:
 *    {
 *      "engine": "Google",
 *      "data": {
 *        "text": "This is a test using sound of text from a linux terminal",
 *        "voice": "en-US"
 *      }
 *    }
 * 2. It will response with an ID if success:
 *    {"success":true,"id":"ce916bf0-c882-11e7-9df0-2f554923557b"}
 * 3. Use this ID to GET the URL of the resulting sound file:
 *    curl -X GET "https://api.soundoftext.com/sounds/ce916bf0-c882-11e7-9df0-2f554923557b" -H  "accept: application/json" -H  "Content-Type: application/json"
 * 4. It will respone with the URL to the file:
 *    {"status":"Done","location":"https://soundoftext.nyc3.digitaloceanspaces.com/ce916bf0-c882-11e7-9df0-2f554923557b.mp3"}
 * 5. Download the file from that URL:
 *    wget https://soundoftext.nyc3.digitaloceanspaces.com/ce916bf0-c882-11e7-9df0-2f554923557b.mp3
*/

using namespace std;

class SoundOfTextApi : public QObject
{
  Q_OBJECT

public:

  // Constructor
  SoundOfTextApi();

  // Destuctor
  ~SoundOfTextApi();

  // Send network request to get the speech of the provided text (1.)
  void sendTextToSpeechNetworkRequest(QString input_text, QString source_lang, QString source_lang_sufix);

signals:
  void onTextToSpeechResult(QString sound_file_path); // (5.RESULT)
  void onErrorResult(QString error);

private slots:

  // Receive QNetworkAccessManager replies (2. & 4.)
  void onSoundOfTextNetworkAnswer(QNetworkReply* reply);

private:

  // Variables
  QNetworkAccessManager *_network_manager;      // System network handler to post request to the online translator
  QString _sound_of_text_url { "https://api.soundoftext.com/sounds" };

  // Send network request to get the sound file URL (3.)
  void sendGetSoundNetworkRequest(QString sound_id);

  // Download the sound file from the URL and return the file_path (5.)
  QString downloadSoundFile(QString sound_url);
};

#endif // SOUNDOFTEXTAPI_H
