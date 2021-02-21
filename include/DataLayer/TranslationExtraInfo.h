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
    Q_PROPERTY(QStringListModel* matchesTranslations READ matchesTranslations NOTIFY matchesTranslationsChanged)
    Q_PROPERTY(QStringListModel* matchesConfidences READ matchesConfidences NOTIFY matchesConfidencesChanged)

    // QML properties getters
    QString result()  {return _result;}
    float confidence()  {return _confidence;}
    bool quotaFinished()  {return _quota_finished;}
    QStringListModel* matchesSources() {return &_matches_sources;}
    QStringListModel* matchesTranslations() {return &_matches_translations;}
    QStringListModel* matchesConfidences() {return &_matches_confidences;}

    // QML properties setters
    Q_INVOKABLE void setResult(QString result);
    Q_INVOKABLE void setConfidence(float confidence);
    Q_INVOKABLE void setQuotaFinished(bool quota_finished);

    // Setters
    void setMatchesSources(QStringList matches_sources);
    void setMatchesTranslations(QStringList matches_translations);
    void setMatchesConfidences(QStringList matches_confidences);

signals:

    // QML properties signals
    void resultChanged();
    void confidenceChanged();
    void quotaFinishedChanged();
    void matchesSourcesChanged();
    void matchesTranslationsChanged();
    void matchesConfidencesChanged();

private:

    // Variables
    QString _result;
    float _confidence;
    bool _quota_finished;
    QStringListModel _matches_sources;
    QStringListModel _matches_translations;
    QStringListModel _matches_confidences;
};


#endif

