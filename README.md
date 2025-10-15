# Adaptive Mesh Refinement Solver for Hypersonic Capsule Entry

This repository contains a 2D finite-volume Euler solver with **adaptive mesh refinement (AMR)**, developed as part of a graduate-level CFD course project.  
The solver models hypersonic flow over a **capsule re-entering the Martian atmosphere**, with automated local mesh refinement near shock regions.

📄 For details on the formulation, numerical methods, and results, see the full project report:  
[Project_2_final_report.pdf](Project_2_final_report.pdf)

---

## 🧩 Overview

The solver numerically solves the **Euler equations** for compressible flow using a first-order finite-volume method.  
The implementation focuses on capturing **shock structures and flow discontinuities** efficiently using adaptive refinement.

### Key Features
- Finite Volume Method (FVM) for 2D unstructured triangular grids  
- HLLE (Harten–Lax–van Leer–Einfeldt) numerical flux for robustness  
- Adaptive refinement based on **Mach jump error thresholding**  
- Inviscid wall and far-field boundary conditions  
- Automatic recalculation of connectivity, normals, and wave speeds after refinement  
- Lift, drag, and moment coefficient computations for varying angles of attack  

---

## ⚙️ Numerical Setup

**Governing Equations:**  
Euler equations for inviscid, compressible flow.

**Gas Model:**  
Martian atmosphere (CO₂) assumed, γ = 1.3.

**Free Stream:**  
Mach number **M∞ = 8**,  
Angle of attack **α = 0°–10°**.

**Boundary Conditions:**  
- Left, top, bottom → Inflow (prescribed free-stream)  
- Right → Supersonic outflow  
- Capsule surface → Inviscid wall (no penetration)

**Initialization:**  
Uniform field initialized at **M = 1.3**, then updated to **M = 8** for simulation runs.

---

## 🧠 Code Structure

| Function | Purpose |
|-----------|----------|
| `geometryinit()` | Reads `.gri` mesh and constructs connectivity, normals, and boundary arrays |
| `initialize()` | Initializes flow variables with free-stream conditions |
| `edgeiteration()` | Computes fluxes over edges using HLLE scheme and applies boundary conditions |
| `timestepping()` | Advances solution in pseudo-time using local wave speeds |
| `L2errorcalc()` | Computes residual norm for convergence monitoring |
| `forcemoment()` | Calculates lift, drag, and moment coefficients |
| `adaptation()` | Performs mesh refinement by splitting cells exceeding Mach jump threshold |

Data structures include connectivity arrays (`E`, `V`), boundary mappings, edge-element associations, and arrays for residuals, fluxes, and flow variables:contentReference[oaicite:0]{index=0}.

---

## 🚀 Adaptive Refinement

Refinement is based on the **Mach jump error** across edges.  
Cells with error exceeding a threshold are split, and the connectivity tables are rebuilt.

**Effect:**  
- Mesh becomes finer near shock regions.  
- Flow discontinuities sharpen across iterations.  
- Convergence improves with adaptive cycles.

---

## 📊 Results Summary

- **L₂ norm** decreases with iteration count.  
- **Pressure coefficient (Cp)** peaks at the capsule stagnation point (θ = 0).  
- Increasing the number of adaptive cycles → finer shock capture.  
- **Cd** (drag coefficient) decreases with angle of attack, while **Cl** and **Cm** increase.

---
