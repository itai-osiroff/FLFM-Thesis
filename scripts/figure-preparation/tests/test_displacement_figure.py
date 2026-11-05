import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import displacement_figure as figure


class DisplacementFigureTest(unittest.TestCase):
    def test_dense7_defaults_and_backward_sampling(self):
        data = {
            "shifts": np.zeros((7, 7, 2)),
            "fields": np.zeros((7, 7, 400, 400, 2), dtype=np.float32),
            "reference": np.array([3, 3]),
        }
        data["fields"][2, 5, 186, 142] = [-2, 1]
        recipe = figure.defaults(data, dense7=True)
        self.assertEqual(recipe["views_ij_zero_based"], [[2, 5], [4, 1]])
        self.assertEqual(recipe["crop_xyxy_zero_based_half_open"], [113, 157, 176, 222])
        self.assertEqual(figure.display(data, recipe)["source_yx"], [188, 141])
        self.assertAlmostEqual(figure.display(data, recipe)["local_limit"], np.sqrt(5))
        recipe["sample_yx_zero_based"] = [0, 0]
        with self.assertRaisesRegex(ValueError, "inside the crop"):
            figure.display(data, recipe)

    def test_workspace_requires_fields_and_matching_shapes(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "workspace.npz"
            np.savez(path, global_rectified_views=np.zeros((2, 2, 3, 4)))
            with self.assertRaisesRegex(ValueError, "pixel_displacements"):
                figure.read_run(path)
            np.savez(path, **{
                key: np.zeros((2, 2, 3, 4)) for key in (*figure.REQUIRED_PRODUCTS, "pixel_rectified_views")
            })
            with self.assertRaisesRegex(ValueError, "shape"):
                figure.read_run(path)


if __name__ == "__main__":
    unittest.main()
