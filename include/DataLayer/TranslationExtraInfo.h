#ifndef TRANSLATIONEXTRAINFO_H
#define TRANSLATIONEXTRAINFO_H

#include <QObject>
#include <QDebug>
#include <QStringListModel>

class TranslationExtraInfo : public QObject
{
    Q_OBJECT

public:

    // Constructor
    TranslationExtraInfo();

    // Destuctor
    ~TranslationExtraInfo();

    // QML properties declarations
    Q_PROPERTY(QString result READ result WRITE setResult NOTIFY resultChanged)
    Q_PROPERTY(float confidence READ confidence WRITE setConfidence NOTIFY confidenceChanged)
    Q_PROPERTY(bool quotaFinished READ quotaFinished WRITE setQuotaFinished NOTIFY quotaFinishedChanged)
    Q_PROPERTY(QStringListModel* matchesSources READ matchesSources NOTIFY matchesSourcesChanged)

    // QML properties getters
    QString result()  {return _result;}
    float confidence()  {return _confidence;}
    bool quotaFinished()  {return _quota_finished;}
    QStringListModel* matchesSources() {return &_matches_sources;}

    // QML properties setters
    Q_INVOKABLE void setResult(QString result);
    Q_INVOKABLE void setConfidence(float confidence);
    Q_INVOKABLE void setQuotaFinished(bool quota_finished);

    // Setters
    void setMatchesSources(QStringList matches_sources);

signals:

    // QML properties signals
    void resultChanged();
    void confidenceChanged();
    void quotaFinishedChanged();
    void matchesSourcesChanged();

private:

    // Variables
    QString _result;
    float _confidence;
    bool _quota_finished;
    QStringListModel _matches_sources;
};


#endif

