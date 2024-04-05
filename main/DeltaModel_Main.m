function DeltaModel_Main(c)
    ccc = 1; 
    %% Load the IC and Input files
    run(fullfile(c.cdSource,c.InputFile)); %Run input file
    disp(['Running file: ',c.InputFile]);

    [c,f1] = checkInputDelta(c);                       % Check the input for errors
    [c,v] = PreallocateVar(c,N);                            % Pre-allocate vectors
    [c,v,xs,Lt]=ArrangeInputs(c,v,Ns,Nd,Ne,N);          % Arrange Inputs for model
    [c,v] = CallICs(c,v,Ns,Ne,Nd,Nb,N);                 % Create initial conditions
    Hbf = eqHbf(c);
    Bbf = eqBbf(c);
    Seq = eqS(c);
    disp(['H: ',num2str(Hbf),'; B: ',num2str(Bbf),'; S: ',num2str(Seq*1e4),'e4'])
    %--------------------------------------------------------------------------------------------
    % Initial Backwater and Width computation
    [c,v,xb] = ICelevations(c,v,N,xs,Lt,Ns,Ne,Nd,Nb);
    etabar0=v.etabar;
    Tcount = 0; nCount = 1;
    PrintVec = c.T0:c.NtoPrint:c.T;
    
    xi_d = c.xi_d;  savedetabardt = 0; saveSs = 0; L0 = c.L0; o=[]; vo=[];
    while Tcount < c.T %Step through time
        c.dt = c.Dt.*c.Tinyears;
        Tcount = Tcount + c.Dt;
        % FIND BED SLOPE & WiDTH DIFFERENTIAL
            [v] = FindDeriv(c,v,xs,Ns,Ne,0.5);
        % Backwater, Width, Qt
            v = CallBackwater(c,v,xi_d,N,xs,Lt,Ns,Ne,Nd,Nb,nCount);
        % EXNER
            [v,detaf_dt_end,Ss] = CallExner(c,v,Ns,Ne,Nd,Nb,Lt,0);
        % UPDATE SHOCK CONDITION
            [xsdot,xbdot] = CallShockCondition(c,v,N,Ne,xs,xb,Lt,detaf_dt_end,Ss,0,1);

        % PLOT/SAVE DATA AT SELECT TIMES
            if Tcount>=PrintVec(ccc) || Plotall==1 
                PlottingFunction(f1,c,v,ccc,Ns,Ne,xs,xb,xsdot,Tcount)
                [o,vo] = SaveDeltaOutput(c,v,o,vo,N,Ns,Ne,nCount,Tcount,xs,xb,xsdot,0,ccc);
                ccc=ccc+1;
            end
            nCount = nCount+1;
        
        %END OF TIMESTEP UPDATES
            [v,N,Ne,xs,xb,Lt,xi_d,~] = EndOfTimestepUpdates(c,v,Ns,Ne,N,xs,xb,xsdot,xbdot,xi_d,Tcount);
           
    end
    save(c.filenameMat,'c','o','vo');
end