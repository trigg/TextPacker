#!/usr/bin/perl
use GD;
do("data.pl");
GD::Image->trueColor(1);

$blockimage = GD::Image->new("comp/terrain.png") || die "Error loading terrain.png";
$blockimage->saveAlpha(1);
$blockimage->alphaBlending(0);

$itemimage = GD::Image->new("comp/items.png") || die "Error loading items.png";
$itemimage->saveAlpha(1);
$itemimage->alphaBlending(0);


for($i=0; $i<256; $i++){
  # Block
  $blockdata = $blockorder[$i];
  if(!$blockdata eq ""){
    $filename = "";
    if($blockdata=~m/br/){
      #Special case - breaking a block
      $filename = $blockdata;
    }else{
      @metasplit = split(/:/, $blockdata);
      @facesplit = split(/-/, $metasplit[0]);
      $id = $facesplit[0];
      $face = $facesplit[1];
      $meta=0;
      if(scalar(@metasplit)==2){
          $meta = $metasplit[1];
      }
      $facestring = "";
      if($face>0){
        $facestring = "-".$face;
      }
      $metastring="";
      if($meta>0){
        $metastring=":".$meta;
      }
      $filename=$id.$metastring.$facestring;
    }
    $bi = GD::Image->new(16,16);
    $bi->saveAlpha(1);
    $bi->alphaBlending(0);
    $x = $i%16;
    $y= ($i-$x)/16;

    $bi->copy($blockimage,0,0,$x*16,$y*16,16,16);
    open(FILE, ">ids/".$filename.".png");
    binmode FILE;
    print FILE $bi->png;
    close FILE;
  }
  # Item
  $itemdata = $itemorder[$i];
  if(!$itemdata eq ""){
    $filename = "";
    if($itemdata=~m/inv/){
      #Special case - breaking a block
      $filename = $itemdata;
    }else{
      @metasplit = split(/:/, $itemdata);
      $id = $metasplit[0];
      $meta=0;
      if(scalar(@metasplit)==2){
          $meta = $metasplit[1];
      }
      $metastring="";
      if($meta>0){
        $metastring=":".$meta;
      }
      $filename=$id.$metastring;
    }
    $ii = GD::Image->new(16,16);
    $ii->saveAlpha(1);
    $ii->alphaBlending(0);
    $x = $i%16;
    $y= ($i-$x)/16;

    $ii->copy($itemimage,0,0,$x*16,$y*16,16,16);
    open(FILE, ">ids/".$filename.".png");
    binmode FILE;
    print FILE $ii->png;
    close FILE;
  }

}
