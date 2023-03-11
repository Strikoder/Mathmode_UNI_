package mmproject
  model mmproject1
  import Modelica.Math.Random;
  import Modelica.Math.Matrices;
  import Modelica.Constants;
  import Modelica.SIunits;
  parameter Integer M = 12;
  parameter Integer N = 120;
  parameter Real w = 0.5;
  parameter Real h = 1;
  parameter Real deltaT = 1;
  parameter Real cp = 3.8;
  parameter Real L = 4.42;
  parameter Real Tm = 5;
  parameter Real Tinf = 6;
  parameter Real l = 4.31323;
  parameter Real delta = 139.547327;
  parameter Real k = 0;
  parameter Real hi = 414.32;
  parameter Integer rows = 131;
  parameter Integer cols = 131;
  Real Dend[rows, cols](start = fill(0, rows, cols));
  Real Temp[rows, cols](start = fill(0, rows, cols));
  Real Grad[rows, cols](start = fill(0, rows, cols));
  Real S[rows, cols](start = fill(0, rows, cols));
  Real nu[rows, cols](start = Modelica.Math.Random.normal(rows, cols, -1, 1));
  Real Final_output[rows,cols];
  equation
  // input order M->N->w->h->deltaT->cp->L->Tm->Tinf->l->delta->k->hi->rows->cols
  nu[rows, cols](start = Modelica.Math.Random.normal(rows, cols, -1, 1));
  Final_output=parts(M,N,w,h,deltaT,cp,L,Tm,Tinf,l,delta,k,hi,rows,cols);
  end mmproject1;

  function parts
  
  protected // input order M->N->w->h->deltaT->cp->L->Tm->Tinf->l->delta->k->hi->rows->cols
  
  input Integer M;
  input Integer N;
  input Real w;
  input Real h;
  input Real deltaT;
  input Real cp;
  input Real L;
  input Real Tm;
  input Real Tinf;
  input Real l;
  input Real delta;
  input Real k;
  input Real hi;
  input Integer rows;
  input Integer cols;
  input Real Dend[131,131];
  input Real Temp[131,131];
  input Real Grad[131,131];
  input Real S[131,131];
  input Real nu[131,131];
  output Real Final[131,131];
  Integer x(start = 0, fixed = true);
  Integer y(start = 0, fixed = true);
  Real Tij_sum = 0;
  Real Tij_sum_w = 0;
  Real Tij;
  Real sum_not_diagonal = 0;
  Real sum_diagonal = 0;
  Real T;
  algorithm
      if y < N then
        if x < M then
          for i in 1:rows loop
            for j in 1:cols loop 
              if i > 1 then
                Tij_sum := Tij_sum + Temp[i-1, j];
                if j > 1 then
                  Tij_sum_w := Tij_sum_w + Temp[i-1, j-1];
                end if;
              end if;
        
              if j > 1 then
                Tij_sum := Tij_sum + Temp[i, j-1];
                if i < rows then
                  Tij_sum_w := Tij_sum_w + Temp[i+1, j-1];
                end if;
              end if;
        
              if i < rows then
                Tij_sum := Tij_sum + Temp[i+1, j];
                if j > 1 then
                  Tij_sum_w := Tij_sum_w + Temp[i+1, j-1];
                end if;
              end if;
        
              if j < cols then
                Tij_sum := Tij_sum + Temp[i, j+1];
                if i < rows then
                  Tij_sum_w := Tij_sum_w + Temp[i+1, j+1];
                end if;
              end if;
              Tij := (Tij_sum + w*Tij_sum_w) / (4 + 4*w);
              Grad[i, j] := (Tij - Temp[i, j]) / ((4 + 4*w) * (1+2*w)*(h*h));
            end for;
          end for;
        // part b
          for i in div(rows-1,2):-1:1 loop
            for j in div(cols-1,2):-1:1 loop
              if Dend[i, j] == 0 then
                Temp[i, j] := Temp[i, j] + hi * deltaT * Grad[i, j] / M;
              end if;
            end for;
          end for;
      
          for i in div(rows-1,2)+1:rows loop
            for j in div(cols-1,2)+1:cols loop
              if Dend[i, j] == 0 then
                Temp[i, j] := Temp[i, j] + hi * deltaT * Grad[i, j] / M;
              end if;
            end for;
          end for;
          x := x + 1;
          // returns to part a
          // part b end
      else
        // part c
        for i in 1:rows loop
          for j in 1:cols loop
            
            if i > 1 then
              sum_not_diagonal := sum_not_diagonal + Dend[i-1,j];
              if j > 1 then
                sum_diagonal := sum_diagonal + Dend[i-1,j-1];
              end if;
            end if;
            if j > 1 then
              sum_not_diagonal := sum_not_diagonal + Dend[i,j-1];
              if i < rows then
                sum_diagonal := sum_diagonal + Dend[i+1,j-1];
              end if;
            end if;
            if i < rows then
              sum_not_diagonal := sum_not_diagonal + Dend[i+1,j];
              if j > 1 then
                sum_diagonal := sum_diagonal + Dend[i+1,j-1];
              end if;
            end if;
            if j < cols then
              sum_not_diagonal := sum_not_diagonal + Dend[i,j+1];
              if i < rows then
                sum_diagonal := sum_diagonal + Dend[i+1,j+1];
              end if;
            end if;
            k := sum_diagonal + sum_not_diagonal;
            if k >= 1 then
              S[i,j] := sum_not_diagonal + w * sum_diagonal - (2.5 + 2.5 * w);
              T := Temp[div(rows-1,2)+1, div(cols-1,2)+1] * (1 + nu[i,j] * delta + l * S[i,j]);
              if Temp[i,j] < T then
                Dend[i,j] := 1;
                Temp[i,j] := Temp[div(rows-1,2)+1, div(cols-1,2)+1];
              end if;
            end if;
          end for;
        end for;
        y := y + 1;
        // part c end
      end if;
    end if;
    for i in 1:rows loop
      for j in 1:cols loop
      Final[i,j] := Dend[i,j];
      end for;
    end for;     
          
        
  end parts;
end mmproject;
