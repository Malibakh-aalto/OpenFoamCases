1. change system/blockMeshDict if you want to change the mesh size and grading
2. change velocity or nu (kinematic viscosity) for the desired Reynolds number
3. "blockMesh" to generate the mesh
4. "foamRun" or "foamRun > log &"
5. "foamMonitor -logscale postProcessing/residuals/0/residuals.dat" to check residuals
6. WOW "paraFoam" to check the results