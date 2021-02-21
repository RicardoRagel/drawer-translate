#include "TranslationExtraInfo.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/
TranslationExtraInfo::TranslationExtraInfo()
{
    qDebug() << "(TranslationExtraInfo) Creating new object ...";
}

TranslationExtraInfo::~TranslationExtraInfo()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void TranslationExtraInfo::setResult(QString result)
{
    _result = result;
    emit resultChanged();
}

void TranslationExtraInfo::setConfidence(float confidence)
{
    _confidence = confidence;
    emit confidenceChanged();
}

void TranslationExtraInfo::setQuotaFinished(bool quota_finished)
{
    _quota_finished = quota_finished;
    emit quotaFinishedChanged();
}

void TranslationExtraInfo::setMatchesSources(QStringList matches_sources)
{
    _matches_sources.setStringList(matches_sources);
    emit matchesSourcesChanged();
}
