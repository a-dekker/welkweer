#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent) {
    settings_ = new QSettings(
        QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) +
            "/org.adekker/welkweer/harbour-welkweer.conf",
        QSettings::NativeFormat);
}
void Settings::setValue(const QString &key, const QVariant &value) {
    settings_->setValue(key, value);
}

QVariant Settings::value(const QString &key,
                         const QVariant &defaultValue) const {
    return settings_->value(key, defaultValue);
}
