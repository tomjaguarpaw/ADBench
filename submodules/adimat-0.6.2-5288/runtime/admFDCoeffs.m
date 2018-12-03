% function z = admFDCoeffs(mode, o, a)
%
% Return coefficients of the FD method mode for derivative order o and
% accuracy a.
%
% Source for the coefficients: see
% http://en.wikipedia.org/wiki/Finite_difference_coefficients,
% retrieved 8.Oct.2011.
%
% There is a mistake in coefficient 6, of 6th order formula for 2nd
% order derivatives: 334/59 is wrong, it should be 1019/180. See
% http://amath.colorado.edu/faculty/fornberg/Docs/MathComp_88_FD_formulas.pdf.
%
% see also admDiffFD, admOptions.
%
% This file is part of the ADiMat runtime environment.
%
% Copyright 2010,2011 Johannes Willkomm, Institute for Scientific Computing
%                     RWTH Aachen University
function z = admFDCoeffs(mode, order, acc)
  persistent coeffs
  if isempty(coeffs)
    coeffs.forward = { ...
        { ...
            [ -1, 1] ...
            [-3/2, 2, -1/2] ... 
            [-11/6  3  -3/2  1/3 ] ...
            [-25/12  4  -3  4/3  -1/4 ] ...
            [-137/60  5  -5  10/3  -5/4  1/5 ] ...
            [-49/20  6  -15/2  20/3  -15/4  6/5  -1/6 ] ...
        }, ...
        { ...
            [1, -2, 1] ...
            [2, -5, 4, -1] ...
            [35/12  -26/3  19/2  -14/3  11/12] ...
            [15/4  -77/6  107/6  -13  61/12  -5/6] ...
            [203/45  -87/5  117/4  -254/9  33/2  -27/5  137/180  ] ...
            [469/90  -223/10  879/20  -949/18  41  -201/10  1019/180  -7/10] ...
        }, ...
        { ...
            [-1  3  -3  1] ...
            [-5/2  9  -12  7  -3/2] ...
            [-17/4  71/4  -59/2  49/2  -41/4  7/4] ...
            [-49/8  29  -461/8  62  -307/8  13  -15/8] ...
            [-967/120  638/15  -3929/40  389/3  -2545/24  268/5  -1849/120  29/15] ...
            [-801/80  349/6  -18353/120  2391/10  -1457/6  4891/30  -561/8  527/30  -469/240] ...
        }, ...
        { ...
            [1  -4  6  -4  1] ...
            [3  -14  26  -24  11  -2] ...
            [35/6  -31  137/2  -242/3  107/2  -19  17/6] ...
            [28/3  -111/2  142  -1219/6  176  -185/2  82/3  -7/2] ...
            [1069/80  -1316/15  15289/60  -2144/5  10993/24  -4772/15  2803/20  -536/15  967/240] ...
        }, ...
                     };
    
    for i=1:length(coeffs.forward)
      if mod(i, 2) == 1
        coeffs.backward{i} = cellfun(@uminus, coeffs.forward{i}, ...
                                     'UniformOutput',false);
      else
        coeffs.backward{i} = coeffs.forward{i};
      end
    end
    
    coeffs.central = { ...
        { ...
            [],                     [ -0.5, 0, 0.5], ...
            [],                [1/12, -2/3, 0, 2/3, -1/12], ...
            [],        [ -1/60, 3/20, -3/4, 0, 3/4, -3/20, 1/60], ...
            [], [1/280, -4/105,  1/5, -4/5, 0, 4/5,  -1/5, 4/105, -1/280], ...
        }, ...
        { ...
            [],                        [ 1,      -2,   1], ...
            [],                [-1/12, 4/3,    -5/2, 4/3, -1/12 ], ...
            [],         [ 1/90  -3/20  3/2   -49/18  3/2  -3/20   1/90  ], ...
            [], [-1/560  8/315   -1/5  8/5  -205/72  8/5   -1/5  8/315  -1/560 ], ...
        }, ...
        { ...
            [],                       [-1/2  1  0      -1      1/2], ...
            [],          [1/8        -1   13/8  0   -13/8        1   -1/8], ...
            [], [-7/240  3/10  -169/120  61/30  0  -61/30  169/120  -3/10  7/240] ...
        }, ...
        { ...
            [],                   [1       -4     6       -4       1], ...
            [],        [-1/6       2    -13/2  28/3    -13/2       2  -1/6  ] ...
            [], [7/240  -2/5  169/60  -122/15  91/8  -122/15  169/60  -2/5  7/240] ...
        } ...
                     };
    
  end

  if nargin >= 0
    z = coeffs;
  end
  if nargin >= 1
    z = z.(mode);
  end
  if nargin >= 2
    if order > length(z)
      error('adimat:admFDCoeffs:derivativeOrderTooLarge', ...
            'no %s finite difference coefficients for order %d', ...
            mode, order);
    end
    z = z{order};
  end
  if nargin >= 3
    if acc > length(z)
      error('adimat:admFDCoeffs:accuracyOrderTooLarger', ...
            'no %s finite difference coefficients for accuracy order %d in set of coefficients for derivative order %d', ...
            mode, acc, order);
    end
    if strcmp(mode, 'central') && mod(acc, 2) ~= 0
      error('adimat:admFDCoeffs:invalidAccuracyOrder', ...
            'no central finite differences, the accuracy order must be even (is %d)', ...
            acc);
    end
    z = z{acc};
  end
% $Id: admFDCoeffs.m 4579 2014-06-20 21:08:32Z willkomm $