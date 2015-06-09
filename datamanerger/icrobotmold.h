#ifndef ICROBOTMOLD_H
#define ICROBOTMOLD_H

#include <QtGlobal>
#include <QString>
#include <QSharedPointer>
#include <QVector>

class ICMoldItem
{
public:
    ICMoldItem():
        seq_(0),
        num_(0),
        subNum_(-1),
        gmVal_(0),
        pos_(0),
        ifVal_(0),
        ifPos_(0),
        sVal_(0),
        dVal_(0),
        flag_(0),
        sum_(0){}

    uint Seq() const { return seq_;}    //序号
    void SetSeq(uint seq) { seq_ = seq; }
    uint Num() const { return num_;}  //步序
    void SetNum(uint nVal) { num_ = nVal; }
    quint8 SubNum() const { return subNum_;}
    void SetSubNum(int num) { subNum_ = num;}
    uint GMVal() const { return gmVal_;}    //类别区分，0是动作组，1是夹具组
    void SetGMVal(uint gmVal) { gmVal_ = gmVal; }
    bool IsAction() const { return (!(GMVal() & 0x80));}
    bool IsClip() const { return GMVal() & 0x80;}
    bool IsEarlyEnd() const { return (IFVal() & 0x80 ) == 0x80;}
    bool IsEarlySpeedDown() const { return (IFVal() & 0x20 ) == 0x20;}

    uint GetEarlyDownSpeed() const { return (IFVal() & 0x1F );}
    void SetEarlyEnd(bool earlyEnd) { earlyEnd ? ifVal_ |= 0x80 : ifVal_ &= 0x7F;}
    void SetEarlySpeedDown(bool earlySpeedDown) { earlySpeedDown ? ifVal_ |= 0x20 : ifVal_ &= 0xDF;}
    void SetEarlyDownSpeed(uint earlyDownSpeed) {ifVal_ = (ifVal_ & ~(0x1f)) | (earlyDownSpeed & 0x1F);}
    bool IsBadProduct() const { return (IFVal() & 0x40) == 0x40;}
    void SetBadProduct(bool badProduct) { badProduct ? ifVal_ |= 0x40 : ifVal_ &= 0xBF;}
    uint IFOtherVal() const { return IFVal() & 0x1F;}
    void SetIFOtherVal(uint val) { ifVal_ &= 0xE0; ifVal_ |= (val & 0x1F);}
    uint Action() const
    {
        if(!IsAction())
        {
            return 0;
        }
        return GMVal() & 0x7F;
    }
    void SetAction(uint action)
    {
        gmVal_ = action;
    }

    uint Clip() const
    {
        if(!IsClip())
        {
            return 0;
        }
        return GMVal() & 0x7F;
    }
    void SetClip(uint clip)
    {
        gmVal_ = clip;
        gmVal_ |= 0x80;
    }

    int Pos() const { return pos_;}    //X位置
    void SetPos(int pos) { pos_ = pos; }
    uint IFVal() const { return ifVal_;}
    void SetIFVal(uint val) { ifVal_ = val; }
    uint IFPos() const { return ifPos_;}
    void SetIFPos(uint pos) { ifPos_ = pos;}


    uint SVal() const { return sVal_;}  //速度，在clip中是次数，堆叠中是选择

    void SetSVal(uint sVal) { sVal_ = sVal; }
    uint DVal() const { return dVal_;}  //延时
    void SetDVal(uint dVal) { dVal_ = dVal; }


    uint Sum() const { return sum_;}  //
    uint ReSum() const;

    void SetValue(uint seq,
                  uint num,
                  quint8 subNum,
                  uint gmVal,
                  uint pos,
                  uint ifVal,
                  uint ifPos,
                  uint sVal,
                  uint dVal,
                  uint sum)
    {
        seq_ = seq;
        num_ = num;
        subNum_ = subNum;
        gmVal_ = gmVal;
        pos_ = pos;
        ifVal_ = ifVal;
        ifPos_ = ifPos;
        sVal_ = sVal;
        dVal_ = dVal;
        sum_ = sum;
    }
    QByteArray ToString() const;
    QVector<quint32> ToDataBuffer() const
    {
        QVector<quint32> ret;
        ret<<seq_<<num_<<((subNum_<< 8) | gmVal_)<<pos_
          <<((ifVal_<< 8) | (ifPos_>>8))<<(((ifPos_ & 0xFF) << 8) | (dVal_ >> 8))
            <<(((dVal_ & 0xFF) << 8) | sVal_)<<sum_;
        return ret;
    }

    int ActualPos() const
    {
        return (QString::number(Pos()) + QString::number(IFPos() & 0xF)).toInt();
    }
    void SetActualPos(int pos)
    {
        int p = pos / 10;
        int d = pos % 10;
        SetPos(p);
        ifPos_ &= 0xFFFFFFF0;
        ifPos_ |= d;
    }

    int ActualIfPos() const
    {
        return IFPos() >> 4;
    }

    void SetActualIfPos(uint pos)
    {
        ifPos_ &= 0x0000000F;
        ifPos_ |= (pos << 4);
    }

    int ActualMoldCount() const
    {
        return ((IFPos() & 0xFF) << 8) | SVal();
    }

    void SetActualMoldCount(uint count)
    {
//        SetIFVal((count >> 8) & 0xFF);
        ifPos_ &= 0xFFFFFF00;
        ifPos_ |= (count >> 8) & 0xFF;
        SetSVal(count & 0xFF);
    }

    QString Comment() const { return comment_;}
    void SetComment(const QString& comment) { comment_ = comment;}

    int Flag() const { return flag_;}
    void SetFlag(int flag) { flag_ = flag;}

private:
    uint seq_;
    uint num_;
    quint8 subNum_;
    uint gmVal_;
    int pos_;
    uint ifVal_;
    uint ifPos_;
    uint sVal_;
    uint dVal_;
    QString comment_;
    int flag_;
    mutable uint sum_;
};

typedef QList<ICMoldItem> ICActionProgram;

class ICRobotMold;

typedef QSharedPointer<ICRobotMold> ICRobotMoldPTR;
class ICRobotMold
{
public:
    ICRobotMold();
    static ICRobotMoldPTR CurrentMold()
    {
        return currentMold_;
    }
    static void SetCurrentMold(ICRobotMold* mold)
    {
        currentMold_ = ICRobotMoldPTR(mold);
    }

    bool ParseActionProgram(const QString& content);

    QVector<quint32> ProgramToDatabuffer() const
    {
        QVector<quint32> ret;
        for(int i = 0; i != actionProgram_.size(); ++i)
        {
            ret += actionProgram_.at(i).ToDataBuffer();
        }
        return ret;
    }

private:
    ICActionProgram actionProgram_;
    static QSharedPointer<ICRobotMold> currentMold_;

};

#endif // ICROBOTMOLD_H
