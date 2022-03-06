#ifndef NOTIFICATIONHELPER_H
#define NOTIFICATIONHELPER_H

#include <QObject>

class QQuickView;

class notificationhelper : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.adekker.welkweer")
public:
    explicit notificationhelper(int &argc, char **argv);
    virtual ~notificationhelper();
public slots:
    void bringToFront();
    void actionInvoked(const QString &text);

private:
    QQuickView *view;
};

#endif // NOTIFICATIONHELPER_H
