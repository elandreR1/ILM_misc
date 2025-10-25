####################################
#    - ISTIC - L3 Info - ILM -     #
####################################

# ce programme en assembleur est le template pour le TP3-4.

.globl main

.eqv	PRINT_INT, 1
.eqv	PRINT_STRING, 4
.eqv	READ_INT, 5
.eqv    EXIT2, 93

.data
a:		.word 0
b:		.word 0
resultat:	.word 0


values:  .word 5, 7, 9, 12, 14, 15, 18, 20, 24, 27, 30, 33, 35, 36, 40, 42
msg:    .asciz "Le PGCD des valeurs : "
res_msg: .asciz " est \n"


.text
main:
    la s0, values  #chargement de l'adresse values[0] dans le registre s0


    lw t0, 0(s0)  # t0 = res = values[0] 


    li t1, 1  #initisalisation d'un index i =1 pour parcourir le tableau 

loop_pgcd:
    li t2, 16       # nombre d'éléments du tableau
    bge t1, t2, end_pgcd  # Si i >= 16, on sort


    slli t3, t1, 2   # i * 4 (décalage mémoire)
    add t4, s0, t3   # Adresse de values[i]
    lw a0, 0(t4)     # Charger values[i] dans a0
    mv a1, t0        # Charger res dans a1


    jal ra, pgcd     # appel de pgcd(a0, a1)
    mv t0, a0        # placement du résultat dans res

    addi t1, t1, 1   # i++
    j loop_pgcd
sll
end_pgcd:
    # Affichage des valeurs du tableau
    la a0, msg
    li a7, 4
    ecall  

    li t1, 0  # Réinitialiser i = 0
print_loop:
    bge t1, t2, print_result  # Si i >= 16, on passe à l'affichage du PGCD

    # Charger values[i]
    slli t3, t1, 2  
    add t4, s0, t3  
    lw a0, 0(t4)  

    li a7, 1  # Print integer
    ecall  

    # Afficher un espace
    li a0, 32  
    li a7, 11  
    ecall  

    addi t1, t1, 1  
    j print_loop

print_result:
    # Afficher " est %d."
    la a0, res_msg
    li a7, 4
    ecall  

    # Afficher le résultat
    mv a0, t0  
    li a7, 1
    ecall  

    # Fin du programme
    li a7, 10
    ecall  






# reutilisation des exercices precedents
pgcd:
    beq a0, a1, end_pgcd_func  # Si a == b, retourner a

pgcd_loop:
    bge a0, a1, sub_a          # Si a >= b, faire a = a - b
    sub a1, a1, a0             # Sinon b = b - a
    j pgcd_loop

sub_a:
    sub a0, a0, a1
    j pgcd_loop

end_pgcd_func:
    jr ra  # Retour