import pathlib
import sys


def find_posts():
    posts_dir = (
        pathlib.Path("/")
        / "Users"
        / "tswast"
        / "Desktop"
        / "Takeout"
        / "Google+ Stream"
        / "Posts"
    )
    return posts_dir.glob("*.html")


def main():
    posts = find_posts()
    for post in sorted(posts):
        print(post)


if __name__ == "__main__":
    main()
