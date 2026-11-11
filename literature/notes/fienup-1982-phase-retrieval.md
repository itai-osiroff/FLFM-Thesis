# Fienup 1982 - Phase retrieval algorithms: a comparison

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

J. R. Fienup, "Phase retrieval algorithms: a comparison", Applied Optics 21(15), 2758-2769, 1 August 1982 (received 19 Feb 1982). No DOI is printed on the paper. Metadata in the assignment matches the printed header and page range (12 pages).

## What was read

File C4e_39.txt (918 lines, whole paper, printed pp. 2758-2769, title page present). Read in full: abstract, Sec. I-IX, Appendix, reference list. Equations are partly garbled in the text extraction. Figures 2 and 5-10 were not viewed as images; only the text describing them was read.

## Why This Matters

It is the standard primary source for iterative Fourier-transform phase retrieval (error-reduction, input-output, gradient methods) and for their practical limits, namely stagnation and the uniqueness question. For the thesis it is background for phase retrieval as a way to recover phase from intensity, not a method the thesis uses.

## Key Claims (paraphrased)

- **Problems addressed (p. 2758, abstract and Sec. I).** Two cases: phase from two intensity measurements (electron microscopy, wavefront sensing), and phase from one Fourier-modulus measurement plus a nonnegativity constraint (astronomy), with emphasis on the second. [anchor: "single intensity measurement plus a non-negativity constraint"]
- **Algorithms compared (pp. 2759-2764).** The error-reduction (Gerchberg-Saxton) algorithm, steepest descent, the conjugate-gradient method, and the input-output family (basic input-output, output-output, hybrid input-output). Damped least squares is judged impractical. [anchor: "Numerous variations on these gradient methods are"]
- **Error-reduction properties (pp. 2759-2761).** The error cannot increase from one iteration to the next. For a single intensity measurement the algorithm equals a double-length-step steepest descent. [anchor: "algorithm can be looked on as a rapid"]
- **Plateaus and slow convergence (p. 2760, Sec. II).** The error plateaus repeatedly and the iteration count needed by error-reduction can be extremely large for the single-measurement case, whereas the other algorithms reach a recognizable image in tens of iterations. [anchor: "painfully slow for the problem of a single intensity"]
- **Stagnation of error-reduction (p. 2764, Sec. VI).** The author notes that this algorithm stagnates after a few iterations. The comparison used a starting point taken from a partly reconstructed satellite image (128 x 128, noise-free Fourier modulus), ten test iterations followed by nine error-reduction iterations. [anchor: "algorithm is that it tends to stagnate after a few itera-"]
- **Result of the comparison (pp. 2764-2765, 2768).** The hybrid input-output algorithm reduced the error most in the test and was the fastest converging algorithm investigated; the gradient methods also converge reasonably fast. The best strategy at the time was to alternate 10-30 hybrid input-output iterations with 5-10 error-reduction iterations. [anchor: "the hybrid input-output algorithm has converged"]
- **Sensitivity of the comparison (p. 2765).** Results depend on the particular data, stage of reconstruction, number of iterations and algorithm parameter, and near the optimum the parameters make the algorithms somewhat unstable. [anchor: "Further development is needed to determine"]
- **Stagnation by truncation (p. 2766, Sec. VII).** A mask (support) constraint that is not centered on the object can truncate part of it, which usually stagnates the algorithm, so a looser mask is advised for later iterations. [anchor: "one might inadvertently be trying to chop off (truncate)"]
- **Stripe stagnation (p. 2766).** The algorithm often stagnates at a local minimum showing stripes across the image. The author thinks it is a convergence problem and not a uniqueness problem. [anchor: "minimum characterized by a pattern of stripes across"]
- **Restarts (p. 2768, Sec. VIII).** When stagnation occurs, restart from different random starting inputs, and reconstruct two or three times, taking agreement as support for uniqueness. [anchor: "reconstruct the image two or three times from the same"]
- **Uniqueness (p. 2768, Sec. IX).** Uniqueness was not studied here and is described as controversial in the literature. For the single-measurement problem the experiments suggest that solutions are usually unique in practice for complicated 2-D objects, even with noisy modulus data. [anchor: "complicated 2-D objects the solution is usually unique"]
- **Overall status (p. 2768).** The author says a practical algorithm exists but that some trial and error is still involved. [anchor: "is still an element of trial and error involved."]
- **Fluorescence, microscopy aberration correction, light field.** Not stated. Electron microscopy is named as an application only in passing.

## Relevance to the thesis

- Supports: G30 only in a background sense (phase retrieval from intensity data, here with Fourier-modulus and support or nonnegativity constraints, and its stagnation and uniqueness limits).
- Does not support: any statement about fluorescence imaging, aberration estimation in microscopes, defocus-based diversity (that is Paxman et al. 1992), or light-field imaging. It must not be cited for claims about modern phase-retrieval performance (the paper is from 1982 with one simulated satellite example).

## Differences to state if cited

- Phase retrieval here needs coherent-wave style constraints (Fourier modulus plus support or nonnegativity) and iterative Fourier transforms; the thesis method uses neither and recovers no phase.
- The single-measurement problem relies on speckle-interferometry data from astronomy, with the object on a dark background.

## Still unread

- Figures were not viewed. The cited speckle-interferometry and uniqueness references (Refs. 10, 18, 19, 22-28) were not read.

## Safe Wording

Iterative Fourier-transform algorithms such as error-reduction and hybrid input-output recover phase from intensity data under support or nonnegativity constraints, but can stagnate before reaching a solution (Fienup 1982, pp. 2764 and 2766).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Algorithm background only. The convergence discussion does not establish global recovery of the true phase or a fluorescence-specific result.
