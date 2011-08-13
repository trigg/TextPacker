#!/usr/bin/perl
use GD;
do("data.pl");

GD::Image->trueColor(1);

$blockimage = new GD::Image(256,256);
$itemimage = new GD::Image(256,256);
$blockimage->saveAlpha(1);
$blockimage->alphaBlending(0);
$itemimage->saveAlpha(1);
$itemimage->alphaBlending(0);


$bbg = $blockimage->colorAllocateAlpha(0,0,0,127);
$ibg = $blockimage->colorAllocateAlpha(0,0,0,127);
$blockimage->filledRectangle(0,0,256,256,$bbg);
$itemimage->filledRectangle(0,0,256,256,$ibg);


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
    $bi = GD::Image->new("ids/".$filename.".png") || die "Error opening ".$filename;
    $blockimage->setBrush($bi);
    $x = $i%16;
    $y= ($i-$x)/16;
    $blockimage->line($x*16+8,$y*16+8,$x*16+8,$y*16+8,gdBrushed);
  }
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
    $ii = GD::Image->new("ids/".$filename.".png") || die "Error opening ".$filename;
    $itemimage->setBrush($ii);
    $x = $i%16;
    $y= ($i-$x)/16;
    $itemimage->line($x*16+8,$y*16+8,$x*16+8,$y*16+8,gdBrushed);
  }

}

open(FILE,">comp/terrain.png");
binmode FILE;
print FILE $blockimage->png();
close FILE;

open(FILE,">comp/items.png");
binmode FILE;
print FILE $itemimage->png();
close FILE;

