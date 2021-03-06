import "types"
import "objects"

-- Find the nearest point of intersection of a ray by brute force.

let cast_ray [n] 'object
             (distance_to: object -> position -> direction -> (bool, f32))
             (dummy: object) (objects: [n]object) (orig: position) (dir: direction)
           : (bool, f32, object) =
    loop (hit, closest_hit_dist, closest_hit_obj) =
         (false, f32.inf, dummy) for i < n do
      (let (new_hit, dist) = distance_to objects[i] orig dir
       in if new_hit && dist < closest_hit_dist
          then (new_hit, dist, objects[i])
          else (hit, closest_hit_dist, closest_hit_obj))

let cast_ray_sphere = cast_ray sphere.distance_to sphere.dummy
let cast_ray_plane = cast_ray plane.distance_to plane.dummy

-- Look for an object closer than a given minimum distance.  Ideally,
-- we'd stop as soon as we find an intersection, but AMDs OpenCL
-- kernel compiler seems to miscompile the resulting while-loop (that
-- was a fun one to debug).
let check_ray [n] 'object
              (distance_to: object -> position -> direction -> (bool, f32))
              (objects: [n]object) (orig: position) (dir: direction) (dist: f32)
            : bool =
  loop hit = false for i < n do
    if !hit then
      let (new_hit,dist') = distance_to (#[unsafe] objects[i]) orig dir
      in if new_hit && dist' < dist then true else hit
    else hit

let check_ray_sphere = check_ray sphere.distance_to
let check_ray_plane = check_ray plane.distance_to
