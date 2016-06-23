#ifndef MPINTERFACE
#define MPINTERFACE
#include <QOBJECT>
#include <time.h>
#include <QTimer>
#include <QTime>
#include <time.h>

class mpInterface : public QObject{
    Q_OBJECT
    //media duration macro's
    Q_PROPERTY(int get_media_duration READ get_media_duration WRITE set_media_duration NOTIFY valueChanged)
    Q_PROPERTY(QString get_media_duration_output READ get_media_duration_output)
    //time elapsed macro's
    Q_PROPERTY(int get_time_elapsed READ get_time_elapsed WRITE set_time_elapsed NOTIFY valueChanged)
    Q_PROPERTY(QString get_time_elapsed_output READ get_time_elapsed_output)
    //play/pause button macro's
    Q_PROPERTY(bool get_is_media_paused READ get_is_media_paused WRITE set_is_media_paused)

public:
    mpInterface();
    ~mpInterface();

    //media duration functions
    int get_media_duration(); //this getter/accessor is only for Q_PROPERTY requirements. QML reads value from media_duration_output
    void set_media_duration(const int val);
    QString get_media_duration_output();

    //time elapsed functions
    int get_time_elapsed();
    void set_time_elapsed(const int val);
    QString get_time_elapsed_output();

    //play/pause button functions
    bool get_is_media_paused();
    void set_is_media_paused(bool val);

    //timer functions
    Q_INVOKABLE void timer_start();
    Q_INVOKABLE void timer_stop();
    Q_INVOKABLE void timer_reset();

signals:
    void valueChanged();

public slots:
    Q_INVOKABLE void time_format();

private:
    mpInterface(const mpInterface & source){}
    mpInterface & operator=(const mpInterface & source){}
    //media duration data members
    int _mediaDuration;
    QString _mediaDurationOutput;
    //time elapsed data members
    int _timeElapsed;
    QString _timeElapsedOutput;
    //timer
    QTimer * _timer;
    //play/pause button
    bool _isMediaPaused;
};

#endif //MPINTERFACE
