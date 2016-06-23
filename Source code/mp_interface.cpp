#include <mp_interface.h>
#include <QDebug>
#include <QTime>
#include <QTimer>
#include <QObject>
#include <time.h>

mpInterface::mpInterface(){

    _timer = new QTimer;
    connect(_timer, SIGNAL(timeout()), this, SLOT(time_format()));
    _timeElapsed = 0;
}

mpInterface::~mpInterface(){
    delete _timer;
}

//this getter/accessor is only for Q_PROPERTY requirements. QML reads value from media_duration_output
int mpInterface::get_media_duration(){
    return _mediaDuration;
}

void mpInterface::set_media_duration(const int val){
   _mediaDuration = val;
}

//this getter/accessor is only for Q_PROPERTY requirements. QML reads value from time_elapsed_output
int mpInterface::get_time_elapsed(){
    return _timeElapsed;
}

void mpInterface::set_time_elapsed(const int val){
    _timeElapsed = val;
}

QString mpInterface::get_media_duration_output(){
    return _mediaDurationOutput;
}

QString mpInterface::get_time_elapsed_output(){
    return _timeElapsedOutput;
}

bool mpInterface::get_is_media_paused(){
    return _isMediaPaused;
}

void mpInterface::set_is_media_paused(bool val){
    _isMediaPaused = val;
}

void mpInterface::time_format(){

    //process media duration
    time_t mdTime = _mediaDuration;
    mdTime /= 1000;
    struct tm * mdPtr = gmtime(&mdTime);
    char mdBuffer[10];
    strftime(mdBuffer,10,"%H:%M:%S",mdPtr);
    _mediaDurationOutput = mdBuffer;

    //process time elapsed
    time_t elapTime = _timeElapsed++;
    struct tm * elapPtr = gmtime(&elapTime);
    char elapBuffer[10];
    strftime(elapBuffer,10,"%H:%M:%S",elapPtr);
    _timeElapsedOutput = elapBuffer;

    if(_timeElapsedOutput == _mediaDurationOutput){
       timer_reset();
       timer_stop();
    }
    _timer->start(1000);
    emit valueChanged();
}

void mpInterface::timer_reset(){
    _timeElapsed = 0;
}

void mpInterface::timer_start(){
    _timer->start();
}

void mpInterface::timer_stop(){
    _timer->stop();
}
