import os,sys
from array import array
from math import sqrt
import ROOT as rt

output_dir="output"
command = "find %s/ | grep .root | sort"%(output_dir)
pinput = os.popen(command)
pout = pinput.readlines()

rootout = rt.TFile("test_output_plot_cosmic_edep.root","recreate")
tedep = rt.TTree("edep","event energy edep")

fedep = array('f',[0.0])
tedep.Branch("fedep",fedep,"fedep/F")

for p in pout:
    p = p.strip()
    try:
        fnum = int(p.split("cosmicgen_fileid")[1].split(".")[0])
        print(fnum," ",p)
    except:
        continue
    
    if fnum>=70:
        break

    finput = p
    print(finput)
    rinput = rt.TFile(finput,"open")
    
    edeptree = rinput.Get("EDepSimEvents")

    nentries = edeptree.GetEntries()
    print(" file has ",nentries," entries")
    for ientry in range(nentries):
        nbytes = edeptree.GetEntry(ientry)
        print("==================================")
        print("ENTRY[",ientry,"]")
        if nbytes<=0:
            print("end of file")
            break
        #print("nbytes: ",nbytes)

        # this dumps out boundary crossing trajectories
        if False:
            ntrajs = edeptree.Event.Trajectories.size()
            for itraj in range(ntrajs):
                traj = edeptree.Event.Trajectories.at(itraj)
                if traj.BoundaryCrossingPoints.size()>0:
                    print("  boundary cross points")
                    m0 = traj.InitialMomentum.M()
                    for i in range(traj.BoundaryCrossingPoints.size()):
                        tp = traj.BoundaryCrossingPoints[i]
                        pt0 = [tp.GetPosition()[j]/10.0 for j in range(3)]
                        p = tp.GetMomentum() # 3-momentum
                        ke = sqrt(p.Mag2()+m0*m0)-m0 # KE=E-m_0
                        print("  [",itraj,":",i,"] (%.1f,%.1f,%.1f) cm"%(pt0[0],pt0[1],pt0[2])," t=%.3f ms"%(tp.GetPosition()[3]/1e6)," KE=%.1f MeV"%(ke))
                    
        ndetectors = edeptree.Event.SegmentDetectors.size()
        #print("ndetectors: ",ndetectors)        
        if ndetectors!=1:
            continue
        
        seghits = edeptree.Event.SegmentDetectors["edepseg"]

        event_edep = 0.0
        nseghits = seghits.size()
        #print("nseghits=",nseghits)
        
        for ihit in range(nseghits):
            hit = seghits.at(ihit)
            event_edep += hit.GetEnergyDeposit()
            
        print("event edep: ",event_edep," MeV")
        fedep[0] = event_edep
        tedep.Fill()

    rinput.Close()
    print("end of file")
    continue

print("save and clean up")
rootout.Write()
rootout.Close()
