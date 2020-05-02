#!/usr/bin/env python3.7

# Link with:
# mkdir -p $HOME/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
# ln -s $OH_MY_GIL_SH/scripts/plugins/jeff/jeff-daemon.py $HOME/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/jeff-daemon.py

import asyncio
import iterm2

async def main(connection):
    connection = await iterm2.Connection.async_create()
    app = await iterm2.async_get_app(connection)

    async with iterm2.FocusMonitor(connection) as monitor:
        while True:
            update = await monitor.async_get_next_update()
            if update.window_changed and update.window_changed.event == iterm2.FocusUpdateWindowChanged.Reason.TERMINAL_WINDOW_BECAME_KEY:
                window = app.get_window_by_id(update.window_changed.window_id)
                if window and window.current_tab and window.current_tab.current_session:
                    session = window.current_tab.current_session
                    profile_name = await session.async_get_variable('profileName')
                    if profile_name == 'Jeff':
                        await session.async_send_text('\003', suppress_broadcast=True) # ctrl+c in ascii
                        await session.async_send_text('jeff\n', suppress_broadcast=True)

# This instructs the script to run the "main" coroutine and to keep running even after it returns.
iterm2.run_forever(main)
