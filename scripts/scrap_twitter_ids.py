from argparse import ArgumentParser

from twitter.scraper import Scraper

parser = ArgumentParser(
    prog="Twitter ids Scrapper",
    description="Scraps the identifiant of Twitter to use with twitter-api-client -- https://github.com/trevorhobenshield/twitter-api-client",
    epilog="",
)

parser.add_argument(
    "email", metavar="email", type=str, nargs=1, help="email of the Twitter account"
)

parser.add_argument(
    "username",
    metavar="username",
    type=str,
    nargs=1,
    help="username of the Twitter account",
)

parser.add_argument(
    "password",
    metavar="password",
    type=str,
    nargs=1,
    help="password of the Twitter account",
)

args = parser.parse_args()

scraper = Scraper(args.email[0], args.username[0], args.password[0])
scraper.save_cookies("twitter_ids")
