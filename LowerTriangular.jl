#  C:\dev\GitHub\autodiff\LowerTriangular.jl
#  AUTOGENERATED FROM C:\dev\GitHub\autodiff\LowerTriangular.ipynb on 2015-07-06T08:00:31
#[heading]
# Lower triangular matrices

using Base.Test
include("MatVec.jl")
# Make matrix from diagonal and strict lower triangle,
# e.g. D = [d11 d22 d33 d44]
#      LT = [L21 L31 L32 L41 L42 L43]
# Outputting
#  [d11   0   0   0]
#  [L21 d12   0   0] # row r: Ls starting at sum_i=1^r
#  [L31 L32 d33   0]
#  [L41 L42 L43 d44]
function ltri_unpack(D::Vec, LT::Vec)
  d=length(D)
  make_row(r::Int, L) = hcat(reshape([ L[i] for i=1:r-1 ],1,r-1), D[r], zeros(1,d-r))
  row_start(r::Int) = div((r-1)*(r-2),2)
  inds(r) = row_start(r)+(1:r-1)
  vcat([ make_row(r, LT[inds(r)]) for r=1:d ]...)
end

ltri_unpack(D, L) = ltri_unpack([Float64(d) for d in D], [Float64(l) for l in L])

@test [11 0 0 0; 21 22 0 0 ; 31 32 33 0 ; 41 42 43 44] == ltri_unpack([11 22 33 44], [21 31 32 41 42 43])

LL = ltri_unpack([1.1 2.2 3.3 4.4], [21 31 32 41 42 43])
@printf("An example lower triangle made from diag and LT=\n%s\n", LL)

function ltri_pack{M<:AbstractMatrix}(L::M)
  d=size(L,1)

  make_row(r::Int, L) = hcat(reshape([ L[i] for i=1:r-1 ],1,r-1), D[r], zeros(1,d-r))
  row_start(r::Int) = (r-1)*(r-2)/2
  diag(L), hcat([L[r,1:r-1] for r=1:d ]...)
end

ltri_pack{T}(L::LowerTriangular{T, Matrix{T}}) = ltri_pack(full(L)) ## Until  packed storage is implemented for those

@test ltri_unpack(ltri_pack(LL)...) == LL

@printf("packed=%s\n", ltri_pack(LL))

