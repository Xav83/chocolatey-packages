import argparse
import datetime
import os
import sys

from twitter.account import Account

message_for_one_version = """The latest version ({}) of #{} {}is now available on @chocolateynuget {}

{} #chocolatey
{}
"""

message_for_several_versions = """The latest versions ({}) of #{} {}are now available on @chocolateynuget {}

{} #chocolatey
{}
"""

DATABASE = {
    "2fast": {
        "twitter_id": "jpweber8",
        "emojis": "🔐🔑🪪",
        "tags": [
            "android",
            "csharp",
            "authentication",
            "password",
            "microsoft",
            "windows",
            "windows10",
            "uwp",
            "apps",
            "totp",
            "authenticator",
        ],
    },
    "64gram": {
        "twitter_id": "",
        "emojis": "🖥️📱📞💬",
        "tags": ["telegram", "desktop", "windows"],
    },
    "achievement-watcher": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️🎮🕹️👾",
        "tags": [
            "steam",
            "notification",
            "uplay",
            "rpcs3",
            "trophy",
            "achievement",
            "tracking",
        ],
    },
    "aemulusmodmanager": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️🎮🕹️👾",
        "tags": [
            "mod",
            "package",
            "manager",
            "persona",
            "pc",
            "windows",
        ],
    },
    "antidupl": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️📋🔂",
        "tags": [
            "graphic",
            "deduplication",
            "image",
        ],
    },
    "arrowdl": {
        "twitter_id": "ArrowDLApp",
        "emojis": "🧑‍💻🖥️⬇️",
        "tags": [
            "crawler",
            "streaming",
            "download",
            "video",
            "webextensions",
            "magnetlink",
            "client",
            "youtube",
            "torrent",
            "downloader",
            "firefox",
            "nativeclient",
        ],
    },
    "biglybt-no-java": {
        "twitter_id": "BiglyBT",
        "emojis": "🧑‍💻🖥️⬇️",
        "tags": [
            "torrent",
            "torrentmanagement",
            "bittorrent",
            "p2p",
            "bittorrentclient",
            "torrentclient",
            "client",
            "torrentdownloader",
            "downloader",
            "i2p",
        ],
    },
    "bizhawk": {
        "twitter_id": "TASVideos",
        "emojis": "🧑‍💻🖥️🎮🕹️👾",
        "tags": [
            "c-sharp",
            "cplusplus",
            "cpp",
            "emulator",
            "emulation",
            "saturn",
            "dotnet",
            "speedrunning",
        ],
    },
    "bsnes-hd": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️🎮🕹️👾",
        "tags": [
            "bsnes",
            "hd",
            "snes",
            "emulator",
            "supernintendo",
            "mode7",
            "highresolution",
            "widescreena",
        ],
    },
    "cairoshell": {
        "twitter_id": "cairoshell",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "shell",
            "csharp",
            "launcher",
            "windows",
            "task",
            "manager",
            "desktop",
            "environment",
        ],
    },
    "ccache": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "ccache",
            "cpp",
            "cplusplus",
            "programming",
            "cache",
            "compiler",
            "gcc",
            "clang",
            "msvc",
        ],
    },
    "cider": {
        "twitter_id": "UseCider",
        "emojis": "🎼🎵🎧🔊",
        "tags": [
            "electron",
            "audio",
            "music",
            "windows",
            "opensource",
            "community",
            "performance",
            "player",
            "discord",
            "lyrics",
            "audioplayer",
            "audiostreaming",
            "cider",
            "electron",
        ],
    },
    "comictagger": {
        "twitter_id": "ComicTagger",
        "emojis": "🏷️",
        "tags": ["comics", "comic", "metadata", "tagging", "tagger"],
    },
    "conan": {
        "twitter_id": "conan_io",
        "emojis": "🐸🧑‍💻🖥️",
        "tags": [
            "conan",
            "cpp",
            "cplusplus",
            "package",
            "manager",
            "packagemanager",
            "cmake",
        ],
    },
    "crowtranslate": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "windows",
            "google",
            "translator",
            "ocr",
            "yandex",
            "bing",
            "qt5",
            "dbusapi",
            "libretranslate",
            "lingva",
        ],
    },
    "discord-history-tracker": {
        "twitter_id": "chylexmc",
        "emojis": "📰🔍🕵️👾",
        "tags": ["javascript", "css", "discord", "bookmark"],
    },
    "dosbox-x": {
        "twitter_id": "greatcodeholio",
        "emojis": "🖥️🎮🕹️👾",
        "tags": ["dosbox", "dos", "emulator"],
    },
    "doxybook2": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️️",
        "tags": [
            "mkdocs",
            "gitbook",
            "vuepress",
            "hugobook",
            "doxygen",
            "documentation",
            "generator",
            "markdown",
        ],
    },
    "downzemall": {
        "twitter_id": "ArrowDLApp",
        "emojis": "🧑‍💻🖥️⬇️",
        "tags": [
            "crawler",
            "streaming",
            "download",
            "video",
            "webextensions",
            "magnet",
            "torrent",
            "firefox",
            "nativeclient",
        ],
    },
    "fanficfare": {
        "twitter_id": "",
        "emojis": "🖥️📖📚🤓",
        "tags": [
            "python",
            "cli",
            "downloader",
            "ebook",
            "epub",
            "fanfiction",
            "calibre",
            "calibreplugin",
        ],
    },
    "faust": {
        "twitter_id": "grame_lyon",
        "emojis": "🖥️🎹🎵🎶🎧",
        "tags": [
            "audio",
            "c",
            "rust",
            "cplusplus",
            "csharp",
            "compiler",
            "cpp",
            "programming",
            "dsp",
            "llvm",
            "dlang",
            "julia",
            "wasm",
            "faust",
            "cmajor",
        ],
    },
    "hidhide": {
        "twitter_id": "NefariusMaximus",
        "emojis": "🖥️🎮🕹️👾",
        "tags": [
            "controller",
            "game",
            "gamepad",
            "videogame",
            "emulation",
            "peripherals",
            "device",
            "input",
            "gaming",
        ],
    },
    "hopsan": {
        "twitter_id": "liu_universitet",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "cpp",
            "fmi",
            "hydraulics",
            "transmissionline",
            "simulation",
            "modeling",
        ],
    },
    "internxt-drive": {
        "twitter_id": "Internxt",
        "emojis": "🧑‍💻🖥️🪙",
        "tags": [
            "windows",
            "macos",
            "linux",
            "cloud",
            "storage",
            "decentralized",
            "blockchain",
            "desktop",
            "cloudstorage",
        ],
    },
    "keepassxc-legacy": {
        "twitter_id": "KeePassXC",
        "emojis": "🧑‍💻🖥️✅🔑🔒",
        "tags": [
            "windows",
            "security",
            "privacy",
            "crossplatform",
            "manager",
            "yubikey",
            "password",
            "keepass",
            "keepassxc",
        ],
    },
    "magpie": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️🔍🕵️",
        "tags": [
            "capture",
            "hlsl",
            "superresolution",
            "magnifier",
            "cppwinrt",
            "fsr",
            "anime4k",
        ],
    },
    "mgba": {
        "twitter_id": "mGBA_emu",
        "emojis": "🖥️🎮🕹️👾",
        "tags": [
            "mgba",
            "gba",
            "gameboy",
            "emulator",
            "gameboyadvance",
            "gameboycolor",
        ],
    },
    "monitorian": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️🔆🕶️",
        "tags": [
            "monitor",
            "display",
            "brightness",
            "luminance",
            "ddcci",
        ],
    },
    "openproject": {
        "twitter_id": "openproject",
        "emojis": "🖥️🕒🗓️⏳",
        "tags": [
            "project",
            "planning",
            "roadmap",
            "bug",
            "tracker",
            "management",
            "kanban",
            "scrum",
            "opensource",
            "chart",
            "workflows",
            "gantt",
        ],
    },
    "phantombot": {
        "twitter_id": "PhantomBot",
        "emojis": "🖥️🎮🕹️👾",
        "tags": [
            "twitter",
            "X",
            "moderation",
            "game",
            "java",
            "streamlabs",
            "youtube",
            "twitchtv",
            "sfx",
            "discord",
            "twitch",
            "bot",
        ],
    },
    "pluginval": {
        "twitter_id": "TracktionSW",
        "emojis": "🖥️🔊🎵🎧🎼🎹",
        "tags": [
            "cpp",
            "audio",
            "plugin",
            "vst",
            "au",
            "vst3",
            "tests",
            "validation",
        ],
    },
    "qrcp": {
        "twitter_id": "qrcp_dev",
        "emojis": "🖥️🧑‍💻⤵️",
        "tags": [
            "cli",
            "golang",
            "utility",
            "commandline",
            "qrcode",
        ],
    },
    "rare": {
        "twitter_id": "legendary_gl",
        "emojis": "🎮🕹️👾",
        "tags": [
            "linux",
            "games",
            "frontend",
            "pyqt5",
            "epicgames",
            "legendary",
            "epicgameslauncher",
        ],
    },
    "signal.portable": {
        "twitter_id": "portapps",
        "emojis": "🚀",
        "tags": [
            "windows",
            "portable",
            "signal",
            "portapps",
        ],
    },
    "sophia": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "windows",
            "gui",
            "script",
            "powershell",
            "tweaks",
            "windows10",
            "sophia",
            "debloat",
            "debloating",
            "windows11",
            "debloater",
            "sophiascript",
        ],
    },
    "sophiapp": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "windows",
            "gui",
            "optimization",
            "windows10",
            "sophia",
            "tweaker",
            "debloat",
            "windows11",
        ],
    },
    "steam-rom-manager": {
        "twitter_id": "SteamGridDB",
        "emojis": "🖥️🎮🕹️👾",
        "tags": ["rom", "steam", "videogame", "games", "gaming"],
    },
    "super-productivity": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️⏳🕒📅🗓️",
        "tags": [
            "productivity",
            "todo",
            "jira",
            "todolist",
            "electronapp",
            "timetracker",
            "taskmanager",
            "hacktoberfest",
            "timetracking",
        ],
    },
    "switchhosts": {
        "twitter_id": "switchhosts",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "electron",
            "hosts",
            "hostsfile",
            "hostseditor",
            "switch-hosts",
            "switchhosts",
        ],
    },
    "twemoji": {
        "twitter_id": "13rac1",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "emoji",
            "linux",
            "font",
            "svginot",
        ],
    },
    "tvrename": {
        "twitter_id": "",
        "emojis": "🧑‍💻🖥️",
        "tags": [
            "monitor",
            "rename",
            "tv",
            "episodes",
            "tvdb",
            "series",
            "shows",
            "renamer",
        ],
    },
    "vysor": {
        "twitter_id": "vysorapp",
        "emojis": "🧑‍💻🖥️📱",
        "tags": [
            "android",
            "ios",
            "apple",
            "windows",
            "desktop",
            "phone",
            "mirror",
        ],
    },
}


class Package:
    def __init__(self, name, version):
        if name not in DATABASE:
            print(
                f'Error: No configuration found for the package "{name}" in the database.'
            )
            sys.exit(-1)

        self.name = name

        if DATABASE[name]["twitter_id"] != "":
            self.twitter_id = "(@{}) ".format(DATABASE[name]["twitter_id"])
        else:
            self.twitter_id = ""

        self.version = str(version).strip("[]").replace("'", "")
        self.emojis = DATABASE[name]["emojis"]
        self.tags = "#" + " #".join(DATABASE[name]["tags"])
        self.url = "https://community.chocolatey.org/packages/" + name
        self.message_template = message_for_several_versions
        if len(version) == 1:
            self.message_template = message_for_one_version

    def __str__(self):
        return self.message_template.format(
            self.version, self.name, self.twitter_id, self.emojis, self.tags, self.url
        )

    def to_string(self):
        return self.__str__()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="Twitter message generator",
        description="Generates a twitter message for a specified package and version",
        epilog="",
    )

    parser.add_argument(
        "package", metavar="package", type=str, nargs=1, help="name of the package"
    )

    parser.add_argument(
        "version",
        metavar="version",
        type=str,
        nargs="+",
        help="version(s) of the package",
    )

    args = parser.parse_args()

    message = Package(args.package[0], args.version)

    if not os.path.isfile("twitter_ids.cookies"):
        print("""Error: File 'twitter_ids.cookies' not found.
            You may want to generate it with the script 'scraper_twitter_ids.py'.
            """)
        sys.exit(1)

    account = Account(cookies="twitter_ids.cookies")
    scheduled_tweets = account.scheduled_tweets()["data"]["viewer"][
        "scheduled_tweet_list"
    ]

    if len(scheduled_tweets) != 0:
        chocolatey_scheduled_tweet = (
            x
            for x in scheduled_tweets
            if "#chocolatey" in x["tweet_create_request"]["status"]
        )
        further_away_tweet = max(
            chocolatey_scheduled_tweet,
            key=lambda tweet: tweet["scheduling_info"]["execute_at"],
        )
        further_away_tweet_date = datetime.datetime.fromtimestamp(
            further_away_tweet["scheduling_info"]["execute_at"] / 1000,
            tz=datetime.timezone.utc,
        )
        new_tweet_date = further_away_tweet_date + datetime.timedelta(days=1)
    else:
        new_tweet_date = datetime.datetime.now() + datetime.timedelta(days=1)

    new_tweet_date = new_tweet_date.replace(hour=6, minute=30, second=0, microsecond=0)
    scheduling_result = account.schedule_tweet(
        message.to_string(), new_tweet_date.strftime("%Y-%m-%d %H:%M")
    )
    if "errors" in scheduling_result:
        print(f"There has been an issue when scheduling the tweet:\n{scheduling_result}")
    else:
        print(f"Tweet scheduled on {new_tweet_date.strftime('%Y-%m-%d %H:%M')}")
