function class=my_classwindow(window,fs)

    classnoise=sum(window==-1);
    
    if(classnoise<0.5*length(window))
        class=0;
    else
        class=1;
    end

end