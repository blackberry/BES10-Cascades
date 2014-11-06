// Default empty project template
#ifndef BESSafeTcp_HPP_
#define BESSafeTcp_HPP_

#include <QObject>

#include <bb/cascades/TextArea>

namespace bb { namespace cascades { class Application; }}

using namespace bb::cascades;

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class BESSafeTcp : public QObject
{
    Q_OBJECT

public:
    BESSafeTcp(bb::cascades::Application *app);
    virtual ~BESSafeTcp() {}

    static void consoleLog(const char* text);
    static void consoleLog(const QString text);

public Q_SLOTS:
    void updateConsole();

private:
    static QString m_consoleText;
    static QTimer *m_timer;

	static TextArea *m_console;

	static BESSafeTcp *m_singleton;
};


#endif /* BESSafeTcp_HPP_ */
