# Copyright 2019 Tim Swast
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import pathlib
import random
import sys

import PIL.Image


def write_noise(im):
    """Write random data to image."""
    width, height = im.size
    num_pixels = width * height
    im_data = list(im.getdata())
    noise_amount = width // 4
    random_data = random.sample(range(256), noise_amount)
    start = random.randrange(num_pixels)
    im_data[start:start + noise_amount] = random_data
    im.putdata(im_data)


def swap_bytes(im):
    width, height = im.size
    num_pixels = width * height
    im_data = list(im.getdata())
    start_from = random.randrange(num_pixels)
    start_to = start_from + random.randrange(7) + 1
    bytes_from = im_data[start_from:start_from + width]
    bytes_to = im_data[start_to:start_to + width]
    im_data[start_to:start_to + width] = bytes_from
    im_data[start_from:start_from + width] = bytes_to
    im.putdata(im_data)


def main(image_path):
    im = PIL.Image.open(image_path)

    glitch_bands = []
    for band_index, band in enumerate("RGB"):
        glitched = im.getchannel(band)
        glitched = glitched.rotate(0, translate=(8 * (band_index - 1), 0))
        for _ in range(6):
            swap_bytes(glitched)
        for _ in range(2):
            write_noise(glitched)
        glitch_bands.append(glitched)

    merged = PIL.Image.merge("RGB", glitch_bands)
    merged.save("{}-glitch.png".format(image_path.stem, band))


if __name__ == "__main__":
    main(pathlib.Path(sys.argv[1]))
