# Cosmic Generation

This runs the g4-coh-lar-750 simulation in order to generate a list of primaries that reach the detector.

We sample from CRY and record only those events that pass into the liquid argon volume.

Those trajectories are the ones we save, dropping all other trajectories and list of primaries to save space.

We will compile such a list of particles to pass into the next stage where the detector response (i.e. scint hits in the pmts) are modeled.

