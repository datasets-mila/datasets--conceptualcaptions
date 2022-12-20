###################
Conceptual Captions
###################

****************************
Creating Conceptual Captions
****************************

For Conceptual Captions, we developed a fully automatic pipeline that extracts,
filters, and transforms candidate image/caption pairs, with the goal of
achieving a balance of cleanliness, informativeness, fluency, and learnability
of the resulting captions. Because no human annotators are involved, the
Conceptual Captions dataset generation process is highly scalable.

To generate this dataset, we started with a `Flume
<//ai.google/research/pubs/pub35650>`__ pipeline that processes billions of
Internet webpages, extracting, filtering, and processing candidate image and
caption pairs, and keeping those that pass through several filters.

We first screen for certain properties like size, aspect ratio, adult content
scores. These filters discard more than 65% of the candidates.  Next, we use
Alt-Texts for text-based filtering, removing captions with non-descriptive text
(such as SEO tags or hashtags); we also discard texts with high sentiment
polarity or adult content scores, resulting in just 3% of the incoming
candidates passing through.

In the next step, we filter out candidates for which none of the text tokens
can be mapped to the visual content of the image. We use image classifiers
(e.g., Google Cloud Vision APIs) to assign class labels to images and match
these labels against the candidate text (allowing `morphological
transformations <//www.aclweb.org/anthology/N15-1186>`__), discarding around
60% of the candidates that reach this stage.

The candidates passing the above filters tend to be good Alt-text image
descriptions. However, a large majority of these use proper names (for people,
venues, locations, etc.), brands, dates, quotes, etc. This creates two distinct
problems. First, some of these cannot be inferred based on the image pixels
alone. This is problematic because unless the image has the necessary visual
information it is not useful for training. Second, even if the proper names
could be inferred from the image it is extremely difficult for a model to learn
to perform both fine-grained classification and natural-language descriptions
simultaneously. We posit that if automatic determination of names, locations,
brands, etc. is needed, it should be done as a separate task that may leverage
image meta-information (e.g. GPS info), or complementary techniques such as
OCR.

We address the above problems with the insight that proper names should be
replaced by words that represent the same general notion, i.e., by their
concept. For example, we remove locations (“Crowd at a concert in Los Angeles“
becomes “Crowd at a concert”), names (e.g., “Former Miss World Priyanka Chopra
on the red carpet” becomes “actor on the red carpet”), proper noun modifiers
(e.g., “Italian cuisine” becomes just “cuisine”) and noun phrases (e.g., “actor
and actor” becomes “actors”).  Around 20% of the samples are discarded during
this transformation because it can leave sentences too short, or otherwise
inconsistent.

Finally, we perform another round of filtering to identify concepts with
low-count. We cluster all resolved entities (e.g., “actor”, “dog”,
“neighborhood”, etc.) and keep only the candidate types which have a count of
over 100 mentions. This retains around 16K entity concepts such as: “person”,
“actor”, “artist”, “player” and “illustration”. The less frequent ones that we
dropped include “baguette”, “bridle”, “deadline”, “ministry” and “funnel”.

*************
Dataset Stats
*************

The resulting dataset (version 1.1) has been split into Training, Validation,
and Test splits. The Training split consists of 3,318,333 image-URL/caption
pairs, with a total number of 51,201 total token types in the captions (i.e.,
total vocabulary). The average number of tokens per captions is 10.3 (standard
deviation of 4.5), while the median is 9.0 tokens per caption. The Validation
split consists of 15,840 image-URL/caption pairs, with similar statistics.

Additionally, we provide machine-generated image labels for a subset of
2,007,528 image-URL/caption pairs from the training set. The image labels are
obtained using the `Google Cloud Vision API <//cloud.google.com/vision>`__.
Each image label has a machine-generated identifier (MID) corresponding to the
label's Google Knowledge Graph entry and a confidence score for its presence in
the image.

***********
Publication
***********

More details on the dataset are available in our `paper
<http://aclweb.org/anthology/P18-1238>`__. (Please note that the paper reports
experimental results using the version 1.0 of the validation and test data.)
Additional details about the versions are available on our `FAQ
</research/ConceptualCaptions/help>`__ page.  Please cite the following paper
if you use or discuss this dataset in your work.

Piyush Sharma, Nan Ding, Sebastian Goodman and Radu Soricut. 2018.  Conceptual
Captions: A Cleaned, Hypernymed, Image Alt-text Dataset For Automatic Image
Captioning. Proceedings of ACL.

Image labels are now included for a subset of 2,007,528 images from the
training set. Please cite the following paper if you use or discuss these image
labels in your work.

Edwin G. Ng, Bo Pang, Piyush Sharma and Radu Soricut. 2020.  Understanding
Guided Image Captioning Performance Across Domains. arXiv preprint
arXiv:2012.02339.

*********
Downloads
*********

`Training split <https://storage.cloud.google.com/gcc-data/Train/GCC-training.tsv?_ga=2.191230122.-1896153081.1529438250>`_

`Validation split <https://storage.cloud.google.com/gcc-data/Validation/GCC-1.1.0-Validation.tsv?_ga=2.141047602.-1896153081.1529438250>`_

`Image Labels <https://storage.cloud.google.com/conceptual-captions-v1-1-labels/Image_Labels_Subset_Train_GCC-Labels-training.tsv?_ga=2.234395421.-20118413.1607637118>`_

***********
Competition
***********

We are hosting a competition that allows for submissions of models for image
captioning. The results obtained by the submitted model(s) are made available
on a leaderboard as part of this competition.

`Participate in Competition <https://ai.google.com/research/ConceptualCaptions/competition>`_
