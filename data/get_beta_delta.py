import numpy as np
import click
import csv

from nist_lookup import xraydb_plugin as xdb


@click.command()
@click.option("--material")
@click.option("--density", type=float)
@click.option("--output", "-o", type=click.File("w"),
              help="output csv file name")
def save_beta_delta(material, density, output):
    output_csv = csv.writer(output)
    output_csv.writerow(["energy", "delta", "beta", "atlen"])
    for energy in range(2, 250):
        delta, beta, atlen = xdb.xray_delta_beta(
            material, density, energy * 1e3)
        output_csv.writerow([energy, delta, beta, atlen])

if __name__ == '__main__':
    save_beta_delta()
