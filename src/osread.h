#ifndef SRC_OSREAD_H_
#define SRC_OSREAD_H_

#include <QObject>
#include <QProcess>

class Launcher : public QObject {
    Q_OBJECT

   public:
    explicit Launcher(QObject *parent = 0);
    ~Launcher();
    Q_INVOKABLE QString launch(const QString &program);

   protected:
    QProcess *m_process;
};

#endif  // SRC_OSREAD_H_
