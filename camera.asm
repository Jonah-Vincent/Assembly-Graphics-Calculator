;Jonah Vincent - Program 1
.386
.MODEL FLAT 

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h
INCLUDE sqrt.h
INCLUDE debug.h

cr EQU 0dh
Lf EQU 0ah

.STACK 4096

computen MACRO dest,n1,n2,n3,e_x,e_y,e_z,a_x,a_y,a_z ;macro that computes the n value
	
	mov dest,e_x
	sub dest,a_x
	mov n1,dest
	
	mov dest,e_y
	sub dest,a_y
	mov n2,dest
	
	mov dest,e_z
	sub dest,a_z
	mov n3,dest
endm

dotproduct MACRO a_x,a_y,a_z,b_x,b_y,b_z,holder1,holder2,holder3 ;macro for computing the dot product
	
	mov ax,a_x
	imul b_x
	mov holder1,ax
	
	
	mov ax,a_y
	imul b_y
	mov holder2,ax
	
	
	mov ax,a_z
	imul b_z
	mov holder3,ax
	
	
	mov ax,0
	add ax,holder1
	add ax,holder2
	add ax,holder3
	mov holder1,ax
endm

scalarmult MACRO multi,x1,x2,x3 ;macro to do scalar multiplication
	
	mov ax,multi
	imul x1
	mov x1,ax
	
	mov ax,multi
	imul x2
	mov x2,ax
	
	mov ax,multi
	imul x3
	mov x3,ax 
	
endm

findv MACRO x1,x2,x3,y1,y2,y3 ;macro that computes the value of v 
	mov ax,0
	add ax,x1
	add ax,y1
	mov y1,ax
	
	mov ax,0
	add ax,x2
	add ax,y2
	mov y2,ax
	
	mov ax,0
	add ax,x3
	add ax,y3
	mov y3,ax
endm

crossproduct MACRO v1,v2,v3,n1,n2,n3,u1,u2,u3 ;macro that computes the cross product 
	mov ax,0
	mov ax,v2
	imul n3
	mov u1,ax
	
	
	mov ax,0
	mov ax,v3
	imul n2
	sub u1,ax
	
	
	mov ax,0
	mov ax,v3
	imul n1
	mov u2,ax
	
	mov ax,0
	mov ax,v1
	imul n3
	sub u2,ax
	
	mov ax,0
	mov ax,v1
	imul n2
	mov u3,ax
	
	mov ax,0
	mov ax,v2
	imul n1
	sub u3,ax
endm

outputcoordinates MACRO i1,i2,i3,array ;macro for outputing the coordinates as the are input in desired format 
	mov array, '('
	itoa array+1,i1
	mov array+7,','
	itoa array+8,i2
	mov array+14,','
	itoa array+15,i3
	mov array+21,')'
	output array
endm
outputfinal MACRO i1,i2,i3,s,array ;macro for outputing the final coordinates in the desired format 
	mov array, '('
	itoa array+5,s
	mov array+7,'/'
	itoa array+1,i1
	mov array+11,','
	itoa array+16,s
	mov array+18,'/'
	itoa array+12,i2
	mov array+22,','
	itoa array+27,s
	mov array+29,'/'
	itoa array+23,i3
	mov array+33,')'
	output array
endm
.DATA
eye1 WORD ?
eye2 WORD ?
eye3 WORD ?
point1 WORD ?
point2 WORD ?
point3 WORD ?
v_up1 WORD ?
v_up2 WORD ?
v_up3 WORD ?
n1 WORD ?
n2 WORD ?
n3 WORD ?
ndotproduct WORD ?
v_upndotproduct WORD ?
v1 WORD ?
v2 WORD ?
v3 WORD ?
u1 WORD ?
u2 WORD ?
u3 WORD ?
holder2 WORD ?
holder3 WORD ?
scalarresult1 WORD ?
scalarresult2 WORD ?
scalarresult3 WORD ?
scalarresult4 WORD ?
scalarresult5 WORD ?
scalarresult6 WORD ?
string BYTE 40 DUP (?)
prompt1 BYTE "Enter the x-coordinate of the camera eyepoint: ", 0
prompt2 BYTE "Enter the y-coordinate of the camera eyepoint: ", 0
prompt3 BYTE "Enter the z-coordinate of the camera eyepoint: ", 0
prompt4 BYTE "Enter the x-coordinate of the camera look at point: ", 0
prompt5 BYTE "Enter the y-coordinate of the camera look at point: ", 0
prompt6 BYTE "Enter the z-coordinate of the camera look at point: ", 0
prompt7 BYTE "Enter the x-coordinate of the camera up direction: ", 0
prompt8 BYTE "Enter the y-coordinate of the camera up direction: ", 0
prompt9 BYTE "Enter the z-coordinate of the camera up direciton: ", 0
promptu BYTE "u:",0
promptv BYTE "v:",0
promptn BYTE "n:",0
test_output BYTE 40 DUP (?)
udotproduct WORD ?
usquareroot WORD ?
finaloutput BYTE 50 DUP (?)
vdotproduct WORD ?
vsquareroot WORD ?
nsquareroot WORD ?

.CODE
_start:
	inputW prompt1, eye1
	outputW eye1
	inputW prompt2, eye2
	outputW eye2
	inputW prompt3, eye3
	outputW eye3
	output carriage
	outputcoordinates eye1,eye2,eye3,test_output
	output carriage
	
	inputW prompt4, point1
	outputW point1
	inputW prompt5, point2
	outputW point2
	inputW prompt6, point3
	outputW point3
	output carriage
	outputcoordinates point1,point2,point3,test_output
	output carriage
	
	inputW prompt7, v_up1
	outputW v_up1
	inputW prompt8, v_up2
	outputW v_up2
	inputW prompt9, v_up3
	outputW v_up3
	output carriage
	outputcoordinates v_up1,v_up2,v_up3,test_output
	output carriage
	
	computen ax,n1,n2,n3,eye1,eye2,eye3,point1,point2,point3 ;computing the values for n (E - A)

	dotproduct n1,n2,n3,n1,n2,n3,ndotproduct,holder2,holder3 ;geting the dot product of n for later use 
	
	dotproduct n1,n2,n3,v_up1,v_up2,v_up3,v_upndotproduct,holder2,holder3 ;getting the dot product of v_up and n for later use 
	
	neg v_upndotproduct
	
	mov ax,n1
	mov scalarresult1,ax
	mov ax,n2
	mov scalarresult2,ax
	mov ax,n3
	mov scalarresult3,ax
	
	scalarmult v_upndotproduct,scalarresult1,scalarresult2,scalarresult3 ;scaler multiplying v_up and n's dot product with n
	
	mov ax,v_up1
	mov scalarresult4,ax
	mov ax,v_up2
	mov scalarresult5,ax
	mov ax, v_up3
	mov scalarresult6,ax
	
	scalarmult ndotproduct,scalarresult4,scalarresult5,scalarresult6 ;scalar multiplying n's dot product of itself with v_up
	
	findv scalarresult1,scalarresult2,scalarresult3,scalarresult4,scalarresult5,scalarresult6 ;using results of scalar multiplication to findv 

	mov ax,scalarresult4
	mov v1,ax
	mov ax,scalarresult5
	mov v2,ax
	mov ax,scalarresult6
	mov v3,ax
	
	crossproduct v1,v2,v3,n1,n2,n3,u1,u2,u3 ;finding cross product of v and n to compute u
	
	dotproduct u1,u2,u3,u1,u2,u3,udotproduct,holder2,holder3 ;finding dot product of u for later use
	sqrt udotproduct
	mov usquareroot,ax
	
	output carriage
	output carriage
	output promptu
	output carriage
	outputfinal u1,u2,u3,usquareroot,finaloutput ;outputing final result of u 
	output carriage
	
	dotproduct v1,v2,v3,v1,v2,v3,vdotproduct,holder2,holder3 ;finding dot product of v for later use
	sqrt vdotproduct
	mov vsquareroot,ax
	output promptv
	output carriage
	outputfinal v1,v2,v3,vsquareroot,finaloutput ;outputing final result for n 
	output carriage
	
	sqrt ndotproduct
	mov nsquareroot,ax
	output promptn
	output carriage
	outputfinal n1,n2,n3,nsquareroot,finaloutput ;outputing final result for n 
	output carriage
	
	INVOKE ExitProcess, 0
	
PUBLIC _start

END 