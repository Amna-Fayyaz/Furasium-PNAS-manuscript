import pandas as pd
import numpy as np
import os
import sys

df = pd.read_csv("file-for-removing-paralogs.csv")
with open("final-paralogs.txt") as f:
    lines = f.read().splitlines()
    cl= df[~df["Cluster"].isin(lines)]
    print(cl.to_csv())
