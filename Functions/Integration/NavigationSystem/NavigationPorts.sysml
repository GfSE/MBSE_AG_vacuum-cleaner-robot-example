package NavigationPorts{

    import ScalarValues::Real;
    port def tire;

    port def LaserTowerPosition{
        out attribute angle : Real;
        out attribute distance: Real;
        }
 
    port def contact;
    port def i2c;
}
