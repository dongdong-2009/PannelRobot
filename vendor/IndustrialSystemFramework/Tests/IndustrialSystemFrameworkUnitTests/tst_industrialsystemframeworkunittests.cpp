#include <QtCore/QString>
#include <QtTest/QtTest>
#include <QtCore/QCoreApplication>
#include "iccommunictioncommandqueue.h"
#include "icvirtualhost.h"
#include "iclevelmanager.h"
#include "icmenubarbase.h"
#include "icflagspool.h"
#include "ictimerpool.h"
#include "iccyclearray.h"
#include "icfuzzycontroller.h"
#include "icfuzzyimplementationbase.h"
#include "iclinguisitcvariable.h"
#include "ictriangularfuzzification.h"
#include "ictemperatureproportionrules.h"
#include "icaddrwrapper.h"

//class MockICTransceiverData : public ICTransceiverData
//{
//public:
//    MockICTransceiverData():id_(0){}
//    MockICTransceiverData(int id):id_(id){}
//    bool IsQuery() const { return false;}
//    bool IsError() const { return false;}
//    bool IsEqual(const ICTransceiverData* other) const
//    {
//        const MockICTransceiverData *data = static_cast<const MockICTransceiverData*>(other);
//        if(data != NULL)
//        {
//            return data->id_ == this->id_;
//        }
//        return false;
//    }
//    uint MaxFrameLength() const { return 256;}

//private:
//    int id_;
//};

//class MockICVirtualHost : public ICVirtualHost
//{
//public:
//    MockICVirtualHost(uint64_t hostId, QObject* parent = 0):
//        ICVirtualHost(hostId, parent){}
//    QByteArray HostStatus(int addr) const { return QByteArray::number(addr);}
//    quint32 HostStatusValue(int addr) const { return addr;}
//protected:
//    bool InitConfigsImpl(const QVector<quint32>& configList, int startAddr)
//    {Q_UNUSED(configList) Q_UNUSED(startAddr)return true;}
//    bool IsInputOnImpl(int index) const {Q_UNUSED(index) return true;}
//    bool IsOutputOnImpl(int index) const {Q_UNUSED(index) return true;}
//    void CommunicateImpl(){}
//    void InitStatusMap_(){}
//    void InitStatusFormatorMap_(){}
//    QBitArray AlarmsImpl() const { return QBitArray();}
//};

//class MockICFrameTransceiverDataMapper: public ICFrameTransceiverDataMapper
//{
//public:
//    bool FrameToTransceiverData(ICTransceiverData* recvData,
//                                const uint8_t* buffer,
//                                size_t size,
//                                const ICTransceiverData* sentData)
//    {Q_UNUSED(recvData) Q_UNUSED(buffer) Q_UNUSED(size) Q_UNUSED(sentData) return true;}
//    size_t TransceiverDataToFrame(uint8_t* dest,
//                                  size_t bufferSize,
//                                  const ICTransceiverData* data)
//    {Q_UNUSED(dest) Q_UNUSED(bufferSize) Q_UNUSED(data) return 0;}
//};

//class MockICLevelManager: public ICLevelManager
//{
//protected:
//    virtual bool LoginImpl(int level, const QString& password)
//    {
//        if(level == 0 && password == "123")
//        {
//            return true;
//        }
//        else if(level == 1 && password == "123")
//        {
//            return true;
//        }
//        else if(level == 2 && password == "123")
//        {
//            return true;
//        }
//        return false;
//    }

//    virtual bool ResetPasswordImpl(int level, const QString& oldPassword, const QString newPassword)
//    {Q_UNUSED(level) Q_UNUSED(oldPassword) Q_UNUSED(newPassword) return true;}
//    virtual QString CurrentLevelStringImpl() const { return QString::number(CurrentLevel());}
//};

//class MockSignalReciever: public QObject
//{
//    Q_OBJECT
//public:
//    MockSignalReciever():hasNoParaSignal_(false), noParaSignalCount_(0),
//        hasOneParaSignal_(false), oneParaSignalCount_(0), widgetPara_(NULL){}
//    bool IsHasNoParaSignal() const { return hasNoParaSignal_;}
//    int NoParaSignalCount() const { return noParaSignalCount_;}
//    bool IsHasOneParaSignal() const { return hasOneParaSignal_;}
//    int OneParaSignalCount() const { return oneParaSignalCount_;}
//    QWidget* OneWidgetPara() { return widgetPara_;}
//private slots:
//    void NoParaSignal() { hasNoParaSignal_ = true; ++noParaSignalCount_;}
//    void OneParaSignal(QWidget* widget) {hasOneParaSignal_ = true; ++oneParaSignalCount_;widgetPara_ = widget;}

//private:
//    bool hasNoParaSignal_;
//    int noParaSignalCount_;
//    bool hasOneParaSignal_;
//    int oneParaSignalCount_;
//    QWidget* widgetPara_;
//};

//class MockICAbstractFlagObserver : public ICAbstractFlagObserver
//{
//public:
//    int FlagVal(int flag) const { return flagToVal_.value(flag);}
//    void Update(int flag, int val)
//    {
//        flagToVal_.insert(flag, val);
//    }

//private:
//    QMap<int, int> flagToVal_;
//};

//class MockICFuzzyImplementationBase : public ICFuzzyImplementationBase
//{
//public:
//    LinguisticLevel LinguisticVariable() const { return LL_Medium;}
//    ICFuzzyMat Fuzzification(double var)
//    {
//        Q_UNUSED(var)
//        ICFuzzyMat mat(7);

//        mat[0].second =  0.1;
//        mat[1].second =  0.2;
//        mat[2].second =  0.3;
//        mat[3].second =  0.4;
//        mat[4].second =  0.5;
//        mat[5].second =  0.6;
//        mat[6].second =  0.7;


//        return mat;
//    }
//    double Singletons(LinguisticVar var) const
//    {
//        return var;
//    }
//};

//Q_DECLARE_METATYPE(MockICTransceiverData*)
//Q_DECLARE_METATYPE(QList<MockICTransceiverData*>)
//Q_DECLARE_METATYPE(MockICFrameTransceiverDataMapper*)
//Q_DECLARE_METATYPE(LinguisticVar)

class IndustrialSystemFrameworkUnitTests : public QObject
{
    Q_OBJECT

public:
    IndustrialSystemFrameworkUnitTests();

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void testCase1();
    void testCase1_data();

    void testICAddrWrapper_UpdateBaseAddrValue();
    void testICAddrWrapper_ExtractValueByAddr();

//    void testICCommunictionCommandQueue_EnQueue();
//    void testICCommunictionCommandQueue_EnQueue_data();
//    void testICCommunictionCommandQueue_DeQueue();
//    void testICCommunictionCommandQueue_DeQueue_data();
//    void testICCommunictionCommandQueue_IsEmpty();

//    void testICVirtualHost_AddCommuncationFrame();
//    void testGetVirtualHost_GetVirtualHost();

//    void testGeneralStatusFormator();
//    void testGeneralStatusFormator_data();
//    void testOneDecimalStatusFormator();
//    void testOneDecimalStatusFormator_data();
//    void testTwoDecimalStatusFormator();
//    void testTwoDecimalStatusFormator_data();

//    void testICLevelManager_Login();
//    void testICLevelManager_Login_data();

//    void testICMenubarBase_AddMenuItem();
//    void testICMenubarBase_MenuItemTriggered();

//    void testICFlagspool();
//    void testICFlagspool_data();
//    void testICTimerPool();

//    void testICCycleArray_Init();
//    void testICCycleArray_Add();
//    void testICCycleArray_RawData();
//    void testICCycleArray_RawData_Bechmark();
//    void testICCycleArray_Clear();

//    void testICTemperatureProportionRules_Interets();
//    void testICFuzzyMat_NonZeroProportions();
//    void testICFuzzyImplementationBase_Init();
//    void testICFuzzyImplementabtionBase_Fuzzification();
//    void testICTriangularFuzzification_Init();
//    void testICTriangularFuzzification_Fuzzification();
//    void testICTriangularFuzzification_Fuzzification_data();
//    void testICTriangularFuzzification_Singletions();
//    void testICFuzzyController_Init();
//    void testICFuzzyController_SetRange();
//    void testICFuzzyController_SetErrorFuzzification();
//    void testICFuzzyController_CalOutput();
//    void testICFuzzyController_CalOutput_data();



};

IndustrialSystemFrameworkUnitTests::IndustrialSystemFrameworkUnitTests()
{
}

void IndustrialSystemFrameworkUnitTests::initTestCase()
{
}

void IndustrialSystemFrameworkUnitTests::cleanupTestCase()
{
}

void IndustrialSystemFrameworkUnitTests::testCase1()
{
    QFETCH(QString, data);
    QVERIFY2(true, "Failure");
}

void IndustrialSystemFrameworkUnitTests::testCase1_data()
{
    QTest::addColumn<QString>("data");
    QTest::newRow("0") << QString();
}

void IndustrialSystemFrameworkUnitTests::testICAddrWrapper_UpdateBaseAddrValue()
{
    uint baseV = 0;
    const ICAddrWrapper  s_rw_4_3_560(3,3,4,3,560,0,"");   //<动模AD通道
    const ICAddrWrapper  s_rw_7_3_560(3,3,7,3,560,0,"");   //<射出AD通道
    const ICAddrWrapper  s_rw_10_3_560(3,3,10,3,560,0,"");   //<座台AD通道
    const ICAddrWrapper  s_rw_13_3_560(3,3,13,3,560,0,"");   //<顶针AD通道
    ICAddrWrapper::UpdateBaseAddrValue(&s_rw_4_3_560,0,&baseV);
    ICAddrWrapper::UpdateBaseAddrValue(&s_rw_7_3_560, 2, &baseV);
    ICAddrWrapper::UpdateBaseAddrValue(&s_rw_13_3_560, 3, &baseV);
    ICAddrWrapper::UpdateBaseAddrValue(&s_rw_10_3_560, 2, &baseV);
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&s_rw_4_3_560,baseV), 0u);
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&s_rw_7_3_560,baseV), 2u);
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&s_rw_13_3_560,baseV), 3u);
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&s_rw_10_3_560,baseV), 2u);
}

void IndustrialSystemFrameworkUnitTests::testICAddrWrapper_ExtractValueByAddr()
{
    uint baseV = 26788;
    ICAddrWrapper addr(3,3,1,1,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, baseV), 0u);
    addr = ICAddrWrapper(3,3,1,2,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, baseV), 2u);
    addr = ICAddrWrapper(3,3,0,16,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, 2147510436), 26788u);
    addr = ICAddrWrapper(3,3,0,32,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, 2147510436), 2147510436u);
    addr = ICAddrWrapper(3,3,0,1,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, baseV), 0u);
    addr = ICAddrWrapper(3,3,7,3,560,0,"");
    QCOMPARE(ICAddrWrapper::ExtractValueByAddr(&addr, 26788), 1u);
}

//void IndustrialSystemFrameworkUnitTests::testICCommunictionCommandQueue_EnQueue()
//{
//    QFETCH(QList<MockICTransceiverData*>, inputFrames);
//    QFETCH(int, queueSize);
//    QFETCH(MockICTransceiverData*, headFrame);
//    ICCommunictionCommandQueue queue;
//    for(int i = 0; i != inputFrames.size(); ++i)
//    {
//        queue.EnQueue(inputFrames.at(i));
//    }
//    QCOMPARE(queue.Size(), queueSize);
//    if(!queue.IsEmpty())
//    {
//        QCOMPARE(queue.Head(), headFrame);
//    }
//    qDeleteAll(inputFrames);
//}

//void IndustrialSystemFrameworkUnitTests::testICCommunictionCommandQueue_EnQueue_data()
//{
//    QTest::addColumn<QList<MockICTransceiverData*> >("inputFrames");
//    QTest::addColumn<int>("queueSize");
//    QTest::addColumn<MockICTransceiverData*>("headFrame");
//    QList<MockICTransceiverData*> frameList;
//    QTest::newRow("Empty")<<frameList<<0<<static_cast<MockICTransceiverData*>(NULL);
//    frameList.append(NULL);
//    QTest::newRow("One NULL Frames")<<frameList<<0<<static_cast<MockICTransceiverData*>(NULL);;
//    frameList.clear();
//    MockICTransceiverData* frame = new MockICTransceiverData();
//    frameList.append(frame);
//    QTest::newRow("One NULL Frames")<<frameList<<1<<frame;
//    frameList.clear();
//    for(int i = 0; i != 100; ++i)
//    {
//        frameList.append(new MockICTransceiverData());
//    }
//    QTest::newRow("Multi Same Frames")<<frameList<<1<<frameList.at(0);
//    frameList.clear();
//    for(int i = 0; i != 100; ++i)
//    {
//        frameList.append(new MockICTransceiverData(i));
//    }
//    QTest::newRow("Multi difference Frames")<<frameList<<100<<frameList.at(0);
//}

//void IndustrialSystemFrameworkUnitTests::testICCommunictionCommandQueue_DeQueue()
//{
//    QFETCH(QList<MockICTransceiverData*>, inputFrames);
//    QFETCH(int, times);
//    QFETCH(int, queueSize);
//    QFETCH(MockICTransceiverData*, headFrame);

//    ICCommunictionCommandQueue queue;
//    for(int i = 0; i != inputFrames.size(); ++i)
//    {
//        queue.EnQueue(inputFrames.at(i));
//    }
//    for(int i = 0; i != times; ++i)
//    {
//        queue.DeQueue();
//    }
//    QCOMPARE(queue.Size(), queueSize);
//    if(!queue.IsEmpty())
//    {
//        QCOMPARE(queue.Head(), headFrame);
//    }
//    for(int i = times; i < inputFrames.size(); ++i)
//    {
//        delete inputFrames[i];
//    }
//}

//void IndustrialSystemFrameworkUnitTests::testICCommunictionCommandQueue_DeQueue_data()
//{
//    QTest::addColumn<QList<MockICTransceiverData*> >("inputFrames");
//    QTest::addColumn<int>("times");
//    QTest::addColumn<int>("queueSize");
//    QTest::addColumn<MockICTransceiverData*>("headFrame");

//    QList<MockICTransceiverData*> frameList;
//    QTest::newRow("Empty Dequeue")<<frameList<<10<<0<<static_cast<MockICTransceiverData*>(NULL);
//    frameList.append(NULL);
//    QTest::newRow("One Frames Delete One")<<frameList<<1<<0<<static_cast<MockICTransceiverData*>(NULL);
//    QTest::newRow("One Frames Delete Multi")<<frameList<<10<<0<<static_cast<MockICTransceiverData*>(NULL);
//    frameList.clear();
//    for(int i = 0; i != 100; ++i)
//    {
//        frameList.append(new MockICTransceiverData(i));
//    }
//    QTest::newRow("Multi difference Frames Delete Multi")<<frameList<<50<<50<<frameList.at(50);
//    frameList.clear();
//    for(int i = 0; i != 100; ++i)
//    {
//        frameList.append(new MockICTransceiverData(i));
//    }
//    QTest::newRow("Multi difference Frames Delete All")<<frameList<<100<<0<<frameList.at(0);
//    frameList.clear();
//    for(int i = 0; i != 100; ++i)
//    {
//        frameList.append(new MockICTransceiverData(i));
//    }
//    QTest::newRow("Multi difference Frames Delete All and more")<<frameList<<200<<0<<frameList.at(0);
//}

//void IndustrialSystemFrameworkUnitTests::testICCommunictionCommandQueue_IsEmpty()
//{
//    ICCommunictionCommandQueue queue;
//    QCOMPARE(queue.IsEmpty(), true);
//    queue.EnQueue(NULL);
//    QCOMPARE(queue.IsEmpty(), true);
//    MockICTransceiverData *frame = new MockICTransceiverData();
//    queue.EnQueue(frame);
//    QCOMPARE(queue.IsEmpty(), false);
//    queue.DeQueue();
//    QCOMPARE(queue.IsEmpty(), true);
//    frame = new MockICTransceiverData(0);
//    queue.EnQueue(frame);
//    frame = new MockICTransceiverData(1);
//    queue.EnQueue(frame);
//    QCOMPARE(queue.IsEmpty(), false);
//    queue.DeQueue();
//    QCOMPARE(queue.IsEmpty(), false);
//    queue.DeQueue();
//    QCOMPARE(queue.IsEmpty(), true);

//}

//void IndustrialSystemFrameworkUnitTests::testICVirtualHost_AddCommuncationFrame()
//{
//    ICVirtualHostPtr host = ICVirtualHostManager::GetVirtualHost<MockICVirtualHost>(1);
//    host->AddCommuncationFrame(NULL);
//    QCOMPARE(host->CommunicationFrameSize(), 0);
//    MockICTransceiverData *data = new MockICTransceiverData(1);
//    host->AddCommuncationFrame(data);
//    QCOMPARE(host->CommunicationFrameSize(), 1);
//    delete data;
//}

//void IndustrialSystemFrameworkUnitTests::testGetVirtualHost_GetVirtualHost()
//{
//    ICVirtualHostPtr host1 = ICVirtualHostManager::GetVirtualHost<MockICVirtualHost>(1);
//    QCOMPARE(host1.isNull(), false);
//    QCOMPARE(host1->HostID(), static_cast<uint64_t>(1));
//    ICVirtualHostPtr host2 = ICVirtualHostManager::GetVirtualHost<MockICVirtualHost>(1);
//    QCOMPARE(host1, host2);
//    ICVirtualHostPtr host3 = ICVirtualHostManager::GetVirtualHost<MockICVirtualHost>(2);
//    QCOMPARE(host1 != host3, true);
//}

//void IndustrialSystemFrameworkUnitTests::testGeneralStatusFormator()
//{
//    QFETCH(quint32, input);
//    QFETCH(QByteArray, output);
//    QCOMPARE(GeneralStatusFormator(input), output);
//}

//void IndustrialSystemFrameworkUnitTests::testGeneralStatusFormator_data()
//{
//    QTest::addColumn<quint32>("input");
//    QTest::addColumn<QByteArray>("output");
//    QTest::newRow("input equal to 0")<<(quint32)0<<QByteArray("0");
//    QTest::newRow("input no equal to 0")<<(quint32)123456<<QByteArray("123456");
//}

//void IndustrialSystemFrameworkUnitTests::testOneDecimalStatusFormator()
//{
//    QFETCH(quint32, input);
//    QFETCH(QByteArray, output);
//    QCOMPARE(OneDecimalStatusFormator(input), output);
//}

//void IndustrialSystemFrameworkUnitTests::testOneDecimalStatusFormator_data()
//{
//    QTest::addColumn<quint32>("input");
//    QTest::addColumn<QByteArray>("output");
//    QTest::newRow("input equal to 0")<<(quint32)0<<QByteArray("0.0");
//    QTest::newRow("input no equal to 0")<<(quint32)123456<<QByteArray("12345.6");
//}

//void IndustrialSystemFrameworkUnitTests::testTwoDecimalStatusFormator()
//{
//    QFETCH(quint32, input);
//    QFETCH(QByteArray, output);
//    QCOMPARE(TwoDecimalStatusFormator(input), output);
//}

//void IndustrialSystemFrameworkUnitTests::testTwoDecimalStatusFormator_data()
//{
//    QTest::addColumn<quint32>("input");
//    QTest::addColumn<QByteArray>("output");
//    QTest::newRow("input equal to 0")<<(quint32)0<<QByteArray("0.00");
//    QTest::newRow("input no equal to 0")<<(quint32)123456<<QByteArray("1234.56");
//}

//void IndustrialSystemFrameworkUnitTests::testICLevelManager_Login()
//{
//    QFETCH(int , level);
//    QFETCH(QString, password);
//    QFETCH(int, currentLevel);
//    MockICLevelManager manager;
//    manager.Login(level, password);
//    QCOMPARE(ICUserCenter::CurrentUser()->Level(), currentLevel);
//    manager.Logout();
//}

//void IndustrialSystemFrameworkUnitTests::testICLevelManager_Login_data()
//{
//    QTest::addColumn<int>("level");
//    QTest::addColumn<QString>("password");
//    QTest::addColumn<int>("currentLevel");
//    QTest::newRow("Level 1 wrong password")<<1<<"12"<<0;
//    QTest::newRow("Level 1 right password")<<1<<"123"<<1;
//    QTest::newRow("Level 2 wrong password")<<2<<"12"<<0;
//    QTest::newRow("Level 2 right password")<<2<<"123"<<2;
//}

//void IndustrialSystemFrameworkUnitTests::testICMenubarBase_AddMenuItem()
//{
////    ICMenuBarBase menuBar;
////    QAbstractButton* button1 =  menuBar.AddMenuItem("Button", Qt::Key_F1, 0);
////    QCOMPARE(button1->text(), QString("Button"));
////    QCOMPARE(menuBar.Count(), 0);
////    QAbstractButton* button2 = menuBar.AddMenuItem("Button", Qt::Key_F1, 1);
////    QCOMPARE(button2->text(), QString("Button"));
////    QCOMPARE(menuBar.Count(), 0);
////    delete button1;
////    delete button2;
//}

//void IndustrialSystemFrameworkUnitTests::testICMenubarBase_MenuItemTriggered()
//{
//    ICMenuBarBase menuBar;
//    MockSignalReciever reciever;
//    connect(&menuBar, SIGNAL(MenuItemTriggered(QWidget*)), &reciever, SLOT(OneParaSignal(QWidget*)));
//    QAbstractButton *button1 = menuBar.AddMenuItem("Button", Qt::Key_F1, 0);
//    QAbstractButton *button2 = menuBar.AddMenuItem("Button", Qt::Key_F1, 1);
//    button1->click();
//    QCOMPARE(reciever.IsHasOneParaSignal(), true);
//    QCOMPARE(reciever.OneParaSignalCount(), 1);
//    QCOMPARE(reciever.OneWidgetPara(), button1);
//    button2->click();
//    QCOMPARE(reciever.OneParaSignalCount(), 2);
//    QCOMPARE(reciever.OneWidgetPara(), button2);
//    button1->click();
//    QCOMPARE(reciever.OneWidgetPara(), button1);
//    delete button1;
//    delete button2;
//}

//void IndustrialSystemFrameworkUnitTests::testICFlagspool()
//{
//    QFETCH(int, flag1);
//    QFETCH(int, flag2);
//    QFETCH(int, value);
//    QFETCH(int, getFlagVal);
//    ICFlagsPool::GlobalInstance()->RegisterFlag(flag1, 0);
//    ICFlagsPool::GlobalInstance()->RegisterFlag(flag2, 0);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->GetFlagValue(0), 0);
//    MockICAbstractFlagObserver observer1;
//    MockICAbstractFlagObserver observer2;
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag1, &observer1), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag1, &observer2), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag1, &observer1), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag1, &observer2), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag2, &observer1), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag2, &observer2), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag2, &observer1), true);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->Attach(flag2, &observer2), true);
//    ICFlagsPool::GlobalInstance()->SetFlagValue(flag1, value);
//    ICFlagsPool::GlobalInstance()->SetFlagValue(flag2, value);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->GetFlagValue(flag1), getFlagVal);
//    QCOMPARE(ICFlagsPool::GlobalInstance()->GetFlagValue(flag2), getFlagVal);
//    QCOMPARE(observer1.FlagVal(flag1), getFlagVal);
//    QCOMPARE(observer2.FlagVal(flag1), getFlagVal);
//    QCOMPARE(observer1.FlagVal(flag2), getFlagVal);
//    QCOMPARE(observer2.FlagVal(flag2), getFlagVal);
//}

//void IndustrialSystemFrameworkUnitTests::testICFlagspool_data()
//{
//    QTest::addColumn<int>("flag1");
//    QTest::addColumn<int>("flag2");
//    QTest::addColumn<int>("value");
//    QTest::addColumn<int>("getFlagVal");
//    QTest::newRow("flag 1")<<1<<2<<1<<1;
//    QTest::newRow("flag same 1")<<1<<2<<2<<2;
//    QTest::newRow("flag 2")<<3<<4<<5<<5;
//    QTest::newRow("navigate flag 2")<<-3<<-4<<5<<5;
//    QTest::newRow("save flag1 and flag 2")<<6<<6<<10<<10;
//}

//void IndustrialSystemFrameworkUnitTests::testICTimerPool()
//{
//    MockSignalReciever recv1;
//    MockSignalReciever recv2;
//    int timerID1 = ICTimerPool::Instance()->Start(20, &recv1, SLOT(NoParaSignal()));
//    int timerID2 = ICTimerPool::Instance()->Start(20, &recv2, SLOT(NoParaSignal()));
//    QCOMPARE(timerID1 != timerID2, true);
//    QTest::qWait(110);
//    QCOMPARE(recv1.NoParaSignalCount(), 5);
//    QCOMPARE(recv2.NoParaSignalCount(), 5);
//    ICTimerPool::Instance()->Stop(timerID1, &recv1, SLOT(NoParaSignal()));
//    ICTimerPool::Instance()->Stop(timerID2, &recv2, SLOT(NoParaSignal()));
//    QTest::qWait(30);
//    QCOMPARE(recv1.NoParaSignalCount(), 5);
//    QCOMPARE(recv2.NoParaSignalCount(), 5);
//}

//void IndustrialSystemFrameworkUnitTests::testICCycleArray_Init()
//{
//    ICCycleArray<int, 100> intArray;
//    QCOMPARE(intArray.Size(), 0);
//    QCOMPARE(intArray.Capacity(), 100);

//    ICCycleArray<char, 50> charArray;
//    QCOMPARE(charArray.Size(), 0);
//    QCOMPARE(charArray.Capacity(), 50);
//}

//void IndustrialSystemFrameworkUnitTests::testICCycleArray_Add()
//{
//    ICCycleArray<int, 3> intArray;
//    intArray.Add(10);
//    QCOMPARE(intArray.Size(), 1);
//    QCOMPARE(intArray.At(0), 10);
//    intArray.Add(15);
//    QCOMPARE(intArray.Size(), 2);
//    QCOMPARE(intArray.At(1), 15);
//    intArray.Add(20);
//    QCOMPARE(intArray.Size(), 3);
//    QCOMPARE(intArray.At(2), 20);
//    intArray.Add(30);
//    QCOMPARE(intArray.Size(), 3);
//    QCOMPARE(intArray.At(0), 15);
//    QCOMPARE(intArray.At(1), 20);
//    QCOMPARE(intArray.At(2), 30);
//    intArray.Add(40);
//    QCOMPARE(intArray.Size(), 3);
//    QCOMPARE(intArray.At(0), 20);
//    QCOMPARE(intArray.At(1), 30);
//    QCOMPARE(intArray.At(2), 40);
//    for(int i = 0; i != 100; ++i)
//    {
//        intArray.Add(i);
//    }
//}

//void IndustrialSystemFrameworkUnitTests::testICCycleArray_RawData()
//{
//    ICCycleArray<int, 3> intArray;
//    intArray.Add(10);
//    intArray.Add(20);
//    intArray.Add(30);
//    int *data = intArray.RawData();
//    QCOMPARE(data[0], 10);
//    QCOMPARE(data[1], 20);
//    QCOMPARE(data[2], 30);
//    intArray.Add(40);
//    data = intArray.RawData();
//    QCOMPARE(intArray.At(2), 40);
//    QCOMPARE(data[0], 20);
//    QCOMPARE(data[1], 30);
//    QCOMPARE(data[2], 40);
//    data = intArray.RawData(1, 2);
//    QCOMPARE(data[0], 30);
//    QCOMPARE(data[1], 40);
//    data = intArray.RawData(2, 2);
//    QCOMPARE(data[0],40);
//    data = intArray.RawData(0, 2);
//    QCOMPARE(data[0], 20);
//    QCOMPARE(data[1], 30);

//    ICCycleArray<double, 10> doubleArray;
//    doubleArray.Add(2);
//    doubleArray.Add(2);
//    doubleArray.Add(2);
//    doubleArray.Add(2);
//    double *data1 = doubleArray.RawData(0, 3);
//    QCOMPARE(data1[0], double(2));
//    QCOMPARE(data1[1], double(2));
//    QCOMPARE(data1[2], double(2));

//}

//void IndustrialSystemFrameworkUnitTests::testICCycleArray_RawData_Bechmark()
//{
//    //    ICCycleArray<int, 10000> intArray;
//    //    for(int i = 0; i != 10000; ++i)
//    //    {
//    //        intArray.Add(i);
//    //    }
//    //    for(int i = 0; i != 5000; ++i)
//    //    {
//    //        intArray.Add(i);
//    //    }
//    //    int *data;
//    //    QBENCHMARK{
//    //        data = intArray.RawData();
//    //    }
//    //    Q_UNUSED(data)
//}

//void IndustrialSystemFrameworkUnitTests::testICCycleArray_Clear()
//{
//    ICCycleArray<int, 3> intArray;
//    intArray.Add(1);
//    intArray.Add(2);
//    intArray.Clear();
//    QCOMPARE(intArray.Size(), 0);
//    intArray.Add(3);
//    QCOMPARE(intArray.At(0), 3);
//}

//void IndustrialSystemFrameworkUnitTests::testICTemperatureProportionRules_Interets()
//{
//    ICTemperatureProportionRules rules;
//    LinguisticVar vars[2] = {LV_PL, LV_NL};
//    QCOMPARE(rules.Interpret(vars ,2), LV_ZO);
//    QCOMPARE(rules.Interpret(vars ,1), LV_NM);
//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyMat_NonZeroProportions()
//{
//    ICFuzzyMat mat(7);
//    mat[0].second = 0;
//    mat[1].second = 0.2;
//    mat[2].second = 0.5;
//    LingProportions p = mat.NonZeronLings();
//    QCOMPARE(p.at(0).second, 0.2);
//    QCOMPARE(p.at(1).second, 0.5);

//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyImplementationBase_Init()
//{
//    MockICFuzzyImplementationBase fuzzyImpl;
//    QCOMPARE(fuzzyImpl.LinguisticVariable(), LL_Medium);
//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyImplementabtionBase_Fuzzification()
//{
//    MockICFuzzyImplementationBase fuzzyImpl;
//    ICFuzzyMat mat = fuzzyImpl.Fuzzification(10.0);

//    QCOMPARE(mat[0].second, 0.1);
//    QCOMPARE(mat[1].second, 0.2);
//    QCOMPARE(mat[2].second, 0.3);
//    QCOMPARE(mat[3].second, 0.4);
//    QCOMPARE(mat[4].second, 0.5);
//    QCOMPARE(mat[5].second, 0.6);
//    QCOMPARE(mat[6].second, 0.7);

//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyController_Init()
//{
//    ICFuzzyController controller;
//    QCOMPARE(controller.OutputRange(), qMakePair(0.0, 10.0));
//    QCOMPARE(controller.ErrorRange(), qMakePair(-10.0, 10.0));
//    QCOMPARE(controller.DErrorRange(), qMakePair(-10.0, 10.0));
//    QCOMPARE(controller.ErrorFuzzification() == NULL, true);
//    QCOMPARE(controller.DErrorFuzzification() == NULL, true);
//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyController_SetRange()
//{
//    ICFuzzyController controller;
//    controller.SetOutputRange(0, 0);
//    QCOMPARE(controller.OutputRange(), qMakePair(0.0, 0.0));
//    controller.SetOutputRange(-10.0, 10.0);
//    QCOMPARE(controller.OutputRange(), qMakePair(-10.0, 10.0));
//    controller.SetErrorRange(0, 0);
//    QCOMPARE(controller.ErrorRange(), qMakePair(0.0, 0.0));
//    controller.SetErrorRange(-10.0, 10.0);
//    QCOMPARE(controller.ErrorRange(), qMakePair(-10.0, 10.0));
//    controller.SetDErrorRange(0, 0);
//    QCOMPARE(controller.DErrorRange(), qMakePair(0.0, 0.0));
//    controller.SetDErrorRange(-10.0, 10.0);
//    QCOMPARE(controller.DErrorRange(), qMakePair(-10.0, 10.0));
//}

////void IndustrialSystemFrameworkUnitTests::testICFuzzyController_SetErrorFuzzification()
////{
////    ICFuzzyController controller;
////    MockICFuzzyImplementationBase fI;
////    controller.SetErrorFuzzification(&fI);
////    controller.SetDErrorFuzzification(&fI);
////    QCOMPARE(controller.ErrorFuzzification() == &fI, true);
////    QCOMPARE(controller.DErrorFuzzification() == &fI, true);
////    //    controller
////}

//void IndustrialSystemFrameworkUnitTests::testICTriangularFuzzification_Init()
//{
//    ICTriangularFuzzification fI;
//    QCOMPARE(fI.LinguisticVariable(), LL_Medium);
//}

//void IndustrialSystemFrameworkUnitTests::testICTriangularFuzzification_Fuzzification()
//{
//    QFETCH(double ,nlMin);
//    QFETCH(double ,nlMax);
//    QFETCH(double ,nmMin);
//    QFETCH(double ,nmMax);
//    QFETCH(double ,nsMin);
//    QFETCH(double ,nsMax);
//    QFETCH(double ,zoMin);
//    QFETCH(double ,zoMax);
//    QFETCH(double ,psMin);
//    QFETCH(double ,psMax);
//    QFETCH(double ,pmMin);
//    QFETCH(double ,pmMax);
//    QFETCH(double ,plMin);
//    QFETCH(double ,plMax);
//    QFETCH(double, sample);
//    QFETCH(double, nlResult);
//    QFETCH(double, nMResult);
//    QFETCH(double, nsResult);
//    QFETCH(double, zoResult);
//    QFETCH(double, psResult);
//    QFETCH(double, pmResult);
//    QFETCH(double, plResult);

//    ICTriangularFuzzification fI;
//    fI.SetNLRange(nlMin, nlMax);
//    fI.SetNMRange(nmMin, nmMax);
//    fI.SetNSRange(nsMin, nsMax);
//    fI.SetZORange(zoMin, zoMax);
//    fI.SetPSRange(psMin, psMax);
//    fI.SetPMRange(pmMin, pmMax);
//    fI.SetPLRange(plMin, plMax);


//    ICFuzzyMat mat = fI.Fuzzification(sample);
//    QCOMPARE(mat[0].second, nlResult);
//    QCOMPARE(mat[1].second, nMResult);
//    QCOMPARE(mat[2].second, nsResult);
//    QCOMPARE(mat[3].second, zoResult);
//    QCOMPARE(mat[4].second, psResult);
//    QCOMPARE(mat[5].second, pmResult);
//    QCOMPARE(mat[6].second, plResult);
//}

//void IndustrialSystemFrameworkUnitTests::testICTriangularFuzzification_Fuzzification_data()
//{
//    QTest::addColumn<double>("nlMin");
//    QTest::addColumn<double>("nlMax");
//    QTest::addColumn<double>("nmMin");
//    QTest::addColumn<double>("nmMax");
//    QTest::addColumn<double>("nsMin");
//    QTest::addColumn<double>("nsMax");
//    QTest::addColumn<double>("zoMin");
//    QTest::addColumn<double>("zoMax");
//    QTest::addColumn<double>("psMin");
//    QTest::addColumn<double>("psMax");
//    QTest::addColumn<double>("pmMin");
//    QTest::addColumn<double>("pmMax");
//    QTest::addColumn<double>("plMin");
//    QTest::addColumn<double>("plMax");
//    QTest::addColumn<double>("sample");
//    QTest::addColumn<double>("nlResult");
//    QTest::addColumn<double>("nMResult");
//    QTest::addColumn<double>("nsResult");
//    QTest::addColumn<double>("zoResult");
//    QTest::addColumn<double>("psResult");
//    QTest::addColumn<double>("pmResult");
//    QTest::addColumn<double>("plResult");

//    QTest::newRow("All Range equal to 0 and sample equal 0")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0;
//    QTest::newRow("All Range equal to 0 and sample non-equal 0")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0;
//    QTest::newRow("nlMin > nlMax and sample > nlMin")<<-1.0<<-2.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0;
//    QTest::newRow("nlMin > nlMax and nlMin>sample > nlMax")<<-1.0<<-2.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<-1.5
//                                        <<1.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0;
//    QTest::newRow("midMin > midMax and sample > midMin")<<0.0<<0.0<<-1.0<<-2.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0;
//    QTest::newRow("midMin > midMax and mindMin > sample > midMax")<<0.0<<0.0<<-1.0<<-2.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<-1.5
//                                        <<1.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0;
//    QTest::newRow("midMin > midMax and mindMin > midMax > sample")<<0.0<<0.0<<-1.0<<-2.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<-3.0
//                                        <<1.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0;
//    QTest::newRow("plMin > plMax and sample > plMin")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<2.0<<1.0<<3.0
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0;
//    QTest::newRow("plMin > plMax and plMin > sample > plMax")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<2.0<<1.0<<1.5
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<1.0;
//    QTest::newRow("plMin > plMax and plMin > plMax > sample")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<2.0<<1.0<<0.5
//                                        <<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0;
//}

//void IndustrialSystemFrameworkUnitTests::testICTriangularFuzzification_Singletions()
//{
//    ICTriangularFuzzification fI;
//    fI.SetNLRange(-10, -8);
//    fI.SetNMRange(-10, -4);
//    fI.SetNSRange(-6, -1);
//    fI.SetZORange(-2, 2);
//    fI.SetPSRange(0, 4);
//    fI.SetPMRange(3, 10);
//    fI.SetPLRange(6, 10);

//    QCOMPARE(fI.Singletons(LV_NL), -9.0);
//    QCOMPARE(fI.Singletons(LV_NM), -7.0);
//    QCOMPARE(fI.Singletons(LV_NS), -3.5);
//    QCOMPARE(fI.Singletons(LV_ZO), 0.0);
//    QCOMPARE(fI.Singletons(LV_PS), 2.0);
//    QCOMPARE(fI.Singletons(LV_PM), 6.5);
//    QCOMPARE(fI.Singletons(LV_PL), 8.0);
//    QCOMPARE(fI.Singletons(LV_NLL), 0.0);
//    QCOMPARE(fI.Singletons(LV_PLL), 0.0);
//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyController_CalOutput()
//{
//    QFETCH(double ,nlMin);
//    QFETCH(double ,nlMax);
//    QFETCH(double ,nmMin);
//    QFETCH(double ,nmMax);
//    QFETCH(double ,nsMin);
//    QFETCH(double ,nsMax);
//    QFETCH(double ,zoMin);
//    QFETCH(double ,zoMax);
//    QFETCH(double ,psMin);
//    QFETCH(double ,psMax);
//    QFETCH(double ,pmMin);
//    QFETCH(double ,pmMax);
//    QFETCH(double ,plMin);
//    QFETCH(double ,plMax);
//    QFETCH(double, error);
//    QFETCH(double, dError);
//    QFETCH(double, result);
//    ICFuzzyController controller;
//    ICTriangularFuzzification fI;
//    fI.SetNLRange(nlMin, nlMax);
//    fI.SetNMRange(nmMin, nmMax);
//    fI.SetNSRange(nsMin, nsMax);
//    fI.SetZORange(zoMin, zoMax);
//    fI.SetPSRange(psMin, psMax);
//    fI.SetPMRange(pmMin, pmMax);
//    fI.SetPLRange(plMin, plMax);
//    ICTriangularFuzzification fO;
//    fO.SetNLRange(nlMin, nlMax);
//    fO.SetNMRange(nmMin, nmMax);
//    fO.SetNSRange(nsMin, nsMax);
//    fO.SetZORange(zoMin, zoMax);
//    fO.SetPSRange(psMin, psMax);
//    fO.SetPMRange(pmMin, pmMax);
//    fO.SetPLRange(plMin, plMax);
//    ICTemperatureProportionRules rules;
//    controller.SetErrorFuzzification(&fI);
//    controller.SetDErrorFuzzification(&fI);
//    controller.SetOutputFuzzification(&fO);
//    controller.SetFuzzyRules(&rules);
//    QCOMPARE(controller.CalOutput(error, dError), result);
//}

//void IndustrialSystemFrameworkUnitTests::testICFuzzyController_CalOutput_data()
//{
//    QTest::addColumn<double>("nlMin");
//    QTest::addColumn<double>("nlMax");
//    QTest::addColumn<double>("nmMin");
//    QTest::addColumn<double>("nmMax");
//    QTest::addColumn<double>("nsMin");
//    QTest::addColumn<double>("nsMax");
//    QTest::addColumn<double>("zoMin");
//    QTest::addColumn<double>("zoMax");
//    QTest::addColumn<double>("psMin");
//    QTest::addColumn<double>("psMax");
//    QTest::addColumn<double>("pmMin");
//    QTest::addColumn<double>("pmMax");
//    QTest::addColumn<double>("plMin");
//    QTest::addColumn<double>("plMax");
//    QTest::addColumn<double>("error");
//    QTest::addColumn<double>("dError");
//    QTest::addColumn<double>("result");

//    QTest::newRow("All equal to 0")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0
//                                                           <<0.0<<0.0<<0.0;
//    QTest::newRow("All Range equal to 0 and error and derror not 0")<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0<<0.0
//                                                           <<1.0<<1.0<<0.0;
//}

QTEST_MAIN(IndustrialSystemFrameworkUnitTests);

#include "tst_industrialsystemframeworkunittests.moc"
