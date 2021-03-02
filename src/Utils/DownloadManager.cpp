#include <QCoreApplication>

#include "DownloadManager.h"

// constructor
DownloadManager::DownloadManager(QString downloads_directory)
{
    // Update directory where save the downloaded files
    _downloads_directory = downloads_directory;
    if(_downloads_directory.back() != '/')
        _downloads_directory.append('/');

    qDebug() << "(DownloadManager) Initialised to save files at " << _downloads_directory;

    // signal finish(), calls downloadFinished()
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(downloadFinished(QNetworkReply*)));
}

void DownloadManager::execute(QStringList urls)
{
    // process each url starting from the 2nd one
    foreach (QString original_url, urls)
    {
        // QString::toLocal8Bit()
        //  - local 8-bit representation of the string as a QByteArray
        // Qurl::fromEncoded(QByteArray)
        //  - Parses input and returns the corresponding QUrl.
        //    input is assumed to be in encoded form,
        //    containing only ASCII characters.

        QUrl url = QUrl::fromEncoded(original_url.toLocal8Bit());

        // makes a request
        doDownload(url);
    }
}

// Constructs a QList of QNetworkReply
void DownloadManager::doDownload(const QUrl &url)
{
    qDebug() << "(DownloadManager) Requesting to download " << url;

    QNetworkRequest request(url);
    QNetworkReply *reply = manager.get(request);

#ifndef QT_NO_SSL
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)), SLOT(sslErrors(QList<QSslError>)));
#endif

    // List of reply
    currentDownloads.append(reply);
}

QString DownloadManager::saveFileName(const QUrl &url)
{
    QString path = url.path();
    QString basename = _downloads_directory + QFileInfo(path).fileName();

    if (basename.isEmpty())
        basename = "download";

    if (QFile::exists(basename)) {
        // already exists, don't overwrite
        int i = 0;
        basename += '.';
        while (QFile::exists(basename + QString::number(i)))
            ++i;

        basename += QString::number(i);
    }

    return basename;
}

void DownloadManager::downloadFinished(QNetworkReply *reply)
{
    QUrl url = reply->url();
    if (reply->error())
    {
        qDebug() << "(DownloadManager) Error downloading " << url.toEncoded().constData() << ". Error: " << reply->errorString();
    }
    else
    {
        QString filename = saveFileName(url);
        qDebug() << "(DownloadManager) Successfull download. Saving it to: " << filename;
        if (saveToDisk(filename, reply))
            printf("Download of %s succeeded (saved to %s)\n",
                   url.toEncoded().constData(), qPrintable(filename));
    }

    currentDownloads.removeAll(reply);
    reply->deleteLater();
}

bool DownloadManager::saveToDisk(const QString &filename, QIODevice *reply)
{
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly)) {
        fprintf(stderr, "Could not open %s for writing: %s\n",
                qPrintable(filename),
                qPrintable(file.errorString()));
        return false;
    }

    file.write(reply->readAll());
    file.close();

    emit downloadFinished(filename);

    return true;
}

void DownloadManager::sslErrors(const QList<QSslError> &sslErrors)
{
#ifndef QT_NO_SSL
    foreach (const QSslError &error, sslErrors)
        fprintf(stderr, "SSL error: %s\n", qPrintable(error.errorString()));
#else
    Q_UNUSED(sslErrors);
#endif
}
