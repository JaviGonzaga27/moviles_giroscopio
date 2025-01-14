import asyncio
import websockets
import webbrowser
import subprocess

async def handle_commands(websocket):
    async for command in websocket:
        if command == 'open_browser':
            webbrowser.open('http://google.com')
        elif command == 'open_office':
            subprocess.Popen(['start', 'winword'], shell=True)
        elif command == 'open_media_player':
            subprocess.Popen(['start', 'ms-media-player:'], shell=True)
            pass

async def main():
    async with websockets.serve(handle_commands, "0.0.0.0", 8080):
        await asyncio.Future()

asyncio.run(main())