#ifndef SRC_SETTINGS_H_
#define SRC_SETTINGS_H_

#include <QObject>
#include <QSettings>

class Settings : public QObject {
    Q_OBJECT
   public:
    explicit Settings(QObject *parent = 0);
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key,
                               const QVariant &defaultValue = QVariant()) const;

   signals:

   public slots:
   private:
    QSettings settings_;
};

#endif  // SRC_SETTINGS_H_
